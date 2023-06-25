pipeline {
    agent any 


    environment {
        AWS_ACCESS_KEY_ID = credentials ('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials ('AWS_SECRET_ACCESS_KEY')
    }
    
    stages {
        stage ("download code and env config") {
            steps {
                sh 'git clone https://github.com/cobidennis/terraCodebase.git'
                sh 'git clone https://github.com/cobidennis/terraEnv.git'
            }
        }
        stage ('plan') {
             steps {
                sh '''
                   cd terraCodebase
                   terraform init -backend-config=../terraEnv/dev/backend.tfvars
                   terraform plan -var-file ../terraEnv/dev/backend.tfvars  -var-file ../terraEnv/dev/ec2.tfvars 
                '''
                script  {
                    env.NEXT_STEP = input message: 'Implement plan?', ok: 'Implement',
                    parameters: [choice (name: 'Implement', choices: 'apply\ndestroy\ndo nothing', description: 'implementation stage')]
                }
            }   

        }
        stage ('implement apply') {
            when {
                expression {
                    env.NEXT_STEP == 'apply'
                }
            }
            steps {
                sh '''
                   cd terraCodebase
                   terraform init -backend-config=../terraEnv/dev/backend.tfvars
                   terraform apply -var-file ../terraEnv/dev/backend.tfvars  -var-file ../terraEnv/dev/ec2.tfvars -auto-approve
                '''
            }
        }
        stage ('implement destroy') {
            when {
                expression {
                    env.NEXT_STEP == 'destroy'
                }
            }
            steps {
                sh '''
                   cd terraCodebase
                   terraform init -backend-config=../terraEnv/dev/backend.tfvars
                   terraform destroy -var-file ../terraEnv/dev/backend.tfvars  -var-file ../terraEnv/dev/ec2.tfvars -auto-approve
                '''
            }
        }
    }
    
    post {
        always {
            deleteDir()
        }
    }
}