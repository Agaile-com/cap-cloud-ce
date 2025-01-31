pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                sh 'npm ci'  // More deterministic than npm install
            }
        }
        
        stage('Lint') {
            steps {
                sh '''
                    if [ -f "package.json" ] && grep -q "lint" "package.json"; then
                        npm run lint
                    else
                        echo "No lint script found in package.json"
                    fi
                '''
            }
        }
    }
    
    post {
        always {
            // Clean workspace after build
            cleanWs()
        }
    }
} 