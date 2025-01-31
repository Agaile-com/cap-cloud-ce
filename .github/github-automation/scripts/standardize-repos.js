// standardize-repos.js
import { Octokit } from "@octokit/rest";
import { config } from 'dotenv';
import fs from 'fs/promises';
import path from 'path';

// Load environment variables from .env file
config();

// Essential environment variables check
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const ORGANIZATION = process.env.ORGANIZATION;

if (!GITHUB_TOKEN) {
    throw new Error('GITHUB_TOKEN environment variable is required');
}
if (!ORGANIZATION) {
    throw new Error('ORGANIZATION environment variable is required');
}

// Configuration file loader with enhanced error handling
async function loadConfigurationFiles() {
    try {
        // Define base configuration path relative to script location
        const configPath = path.join(process.cwd(), 'config');
        
        // Load and parse branch protection rules
        const branchProtection = JSON.parse(
            await fs.readFile(
                path.join(configPath, 'branch-protection.json'), 
                'utf8'
            )
        );
        
        // Load and parse team permission settings
        const teamPermissions = JSON.parse(
            await fs.readFile(
                path.join(configPath, 'team-permissions.json'), 
                'utf8'
            )
        );
        
        // Validate configuration structure
        if (!branchProtection.branch_protection_rules) {
            throw new Error('Invalid branch protection configuration');
        }
        
        return { branchProtection, teamPermissions };
    } catch (error) {
        if (error.code === 'ENOENT') {
            console.error('Configuration files not found. Please ensure config/branch-protection.json and config/team-permissions.json exist');
        } else {
            console.error('Error loading configuration files:', error);
        }
        throw error;
    }
}

// Main repository settings application function
async function applyRepositorySettings(octokit, organization, repository, configs) {
    console.log(`\n📝 Configuring repository: ${organization}/${repository}`);
    
    try {
        // Verify repository exists and is accessible
        try {
            await octokit.repos.get({
                owner: organization,
                repo: repository
            });
        } catch (error) {
            throw new Error(`Repository ${repository} not found or no access`);
        }
        
        // Apply branch protection rules
        console.log('Applying branch protection rules...');
        await applyBranchProtection(
            octokit, 
            organization, 
            repository, 
            configs.branchProtection
        );
        
        // Apply team permissions
        console.log('Applying team permissions...');
        await applyTeamPermissions(
            octokit, 
            organization, 
            repository, 
            configs.teamPermissions
        );
        
        console.log(`✅ Successfully configured ${repository}`);
    } catch (error) {
        console.error(`❌ Error configuring ${repository}:`);
        console.error(`   ${error.message}`);
    }
}

// Branch protection rules application
async function applyBranchProtection(octokit, organization, repository, rules) {
    for (const rule of rules.branch_protection_rules) {
        console.log(`Applying protection rule to ${rule.name} branch`);
        
        try {
            await octokit.repos.updateBranchProtection({
                owner: organization,
                repo: repository,
                branch: rule.name,
                required_status_checks: rule.protect.required_status_checks,
                enforce_admins: true,
                required_pull_request_reviews: 
                    rule.protect.required_pull_request_reviews,
                restrictions: rule.protect.restrictions,
                allow_force_pushes: rule.protect.allow_force_pushes,
                allow_deletions: rule.protect.allow_deletions
            });
        } catch (error) {
            console.error(
                `Failed to apply branch protection to ${rule.name}:`, 
                error.message
            );
            throw error;
        }
    }
}

// Team permissions application
async function applyTeamPermissions(octokit, organization, repository, permissions) {
    for (const [team, settings] of Object.entries(permissions)) {
        console.log(`Setting permissions for team: ${team}`);
        
        try {
            await octokit.teams.addOrUpdateRepoPermissionsInOrg({
                org: organization,
                team_slug: team,
                owner: organization,
                repo: repository,
                permission: settings.permission
            });
        } catch (error) {
            console.error(
                `Failed to set permissions for team ${team}:`, 
                error.message
            );
            throw error;
        }
    }
}

// Main execution function
async function main() {
    // Initialize GitHub client with authentication token
    const octokit = new Octokit({ auth: GITHUB_TOKEN });
    
    // Define CAP Community Edition repositories
    const repositories = [
        'cap-frontend-ce',
        'cap-ingestion-ce',
        'cap-engine-ce',
        'cap-engine-lite-ce',
        'cap-cloud-ce'
    ];
    
    try {
        // Load configuration files
        const configs = await loadConfigurationFiles();
        
        // Process each repository
        for (const repository of repositories) {
            await applyRepositorySettings(
                octokit, 
                ORGANIZATION, 
                repository, 
                configs
            );
        }
        
        console.log('\n🎉 All repositories have been configured successfully!');
    } catch (error) {
        console.error('\n❌ Failed to complete configuration:', error.message);
        process.exit(1);
    }
}

// Execute the script and handle any unhandled errors
main().catch(error => {
    console.error('\n💥 Unhandled error:', error);
    process.exit(1);
});