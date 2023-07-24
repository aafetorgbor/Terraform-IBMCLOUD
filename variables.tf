variable "kibana_password" {
  description = "Kibana password"
  type        = string
  default = ""
  sensitive   = true
}

variable "elastic_password" {
  description = "Elastic password"
  type        = string
  default = ""
  sensitive   = true
}

variable "database_password" {
  description = "Database password-new"
  type        = string
  default = ""
  sensitive   = true
}

variable "access_key" {
  description = "Remote state file access key"
  type        = string
  default = ""
  sensitive   = true
}

variable "secret_key" {
  description = "Remote state file secret key"
  type        = string
  default = ""
  sensitive   = true
}

variable "registry_apikey" {
  description = "Registry access apikey or password"
  type        = string
  default = ""
  sensitive   = true
}




pipeline {
    agent any

    environment{
        
       IBMCLOUD_API_KEY = credentials('jenkins-terraform-ibmcloud-api-key')
       KIBANA_PASSWORD = credentials('kibana-password')
       ELASTIC_PASSWORD = credentials('elastic-password')
       DATABASE_PASSWORD = credentials('database-password')
       REGISTRY_ACCESS_APIKEY = credentials('jenkins-terraform-ibmcloud-api-key')
       
       // Remote state file (ibm cloud object storage)
       ACCESS_KEY = credentials('access-key')
       SECRET_KEY = credentials('secret-key')
    }

    stages {
        stage('check code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/aafetorgbor/Terraform-IBMCLOUD.git']]])
            }
        }

        
        stage('Terraform Init & validate') {
            steps {
                sh '''#!/bin/bash
                
                terraform init
                terraform validate
                
                  '''
            }
        }
        
         
        stage('Terraform Plan') {
            steps {
                sh '''#!/bin/bash
                #export IC_API_KEY=${IBMCLOUD_API_KEY}
                ibmcloud login --apikey ${IBMCLOUD_API_KEY}
                export TF_VAR_kibana_password=${KIBANA_PASSWORD}
                export TF_VAR_elastic_password=${ELASTIC_PASSWORD}
                export TF_VAR_database_password=${DATABASE_PASSWORD}
                export TF_VAR_registry_apikey=${REGISTRY_ACCESS_APIKEY}
                
                export TF_VAR_access_key=${ACCESS_KEY}
                export TF_VAR_secret_key=${SECRET_KEY}
                
                terraform plan 
                
                  '''
            }
        }
        
        stage('Terraform Apply') {
            
             input {
                message "Ready to Deploy/Create?"
                ok "Yes"
                parameters {
                    string(name: "Deploy to", defaultValue: "CODE ENGINE dev")
                }
            }
            steps {
                sh '''#!/bin/bash
                
                #export IC_API_KEY=${IBMCLOUD_API_KEY}
                export TF_VAR_kibana_password=${KIBANA_PASSWORD}
                export TF_VAR_elastic_password=${ELASTIC_PASSWORD}
                export TF_VAR_database_password=${DATABASE_PASSWORD}
                export TF_VAR_registry_apikey=${REGISTRY_ACCESS_APIKEY}
                
                export TF_VAR_access_key=${ACCESS_KEY}
                export TF_VAR_secret_key=${SECRET_KEY}
                
                terraform apply -auto-approve
                
                  '''
            }
        }
    }
}

