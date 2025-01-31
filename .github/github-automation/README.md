# GitHub Repository Automation

This directory contains scripts to automate and standardize GitHub repository settings across CAP Community Edition repositories.

## Initial Setup Results

The script was successfully executed to set up standardized permissions and protections across all CAP Community Edition repositories. Here's what was configured:

### Branch Protection Rules
- Applied protection rules to the `main` branch
- Enabled admin enforcement
- Set up required pull request reviews
- Configured branch restrictions
- Set force push and deletion policies

### Team Permissions
The following teams were configured with specific access levels:
- `community-cap`
- `contributors-cap`
- `maintainers-cap`

### Affected Repositories
The standardization was applied to:
- cap-frontend-ce
- cap-ingestion-ce
- cap-engine-ce
- cap-engine-lite-ce
- cap-cloud-ce

The output below shows the successful execution of these configurations.



Inital run:

MBP-M3 github-automation % npm run start

> @cap/github-automation@1.0.0 start
> node scripts/standardize-repos.js


📝 Configuring repository: Agaile-com/cap-frontend-ce
Applying branch protection rules...
Applying protection rule to main branch
Applying team permissions...
Setting permissions for team: community-cap
Setting permissions for team: contributors-cap
Setting permissions for team: maintainers-cap
✅ Successfully configured cap-frontend-ce

📝 Configuring repository: Agaile-com/cap-ingestion-ce
Applying branch protection rules...
Applying protection rule to main branch
Applying team permissions...
Setting permissions for team: community-cap
Setting permissions for team: contributors-cap
Setting permissions for team: maintainers-cap
✅ Successfully configured cap-ingestion-ce

📝 Configuring repository: Agaile-com/cap-engine-ce
Applying branch protection rules...
Applying protection rule to main branch
Applying team permissions...
Setting permissions for team: community-cap
Setting permissions for team: contributors-cap
Setting permissions for team: maintainers-cap
✅ Successfully configured cap-engine-ce

📝 Configuring repository: Agaile-com/cap-engine-lite-ce
Applying branch protection rules...
Applying protection rule to main branch
Applying team permissions...
Setting permissions for team: community-cap
Setting permissions for team: contributors-cap
Setting permissions for team: maintainers-cap
✅ Successfully configured cap-engine-lite-ce

📝 Configuring repository: Agaile-com/cap-cloud-ce
Applying branch protection rules...
Applying protection rule to main branch
Applying team permissions...
Setting permissions for team: community-cap
Setting permissions for team: contributors-cap
Setting permissions for team: maintainers-cap
✅ Successfully configured cap-cloud-ce

🎉 All repositories have been configured successfully!
ivo@Ivos-MBP-M3 github-automation % 