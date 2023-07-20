# Terraform remote state in ibm cloud object storage
terraform {
  backend "s3" {
    bucket                      = "my-cos-bucket"
    key                         = "ibmcloud-project-state-file/terraform.tfstate"
    region                      = "us-east"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    endpoint                    = "s3.us-east.cloud-object-storage.appdomain.cloud"

    access_key                  = "982265d700cd4f6490990f5b6f841ac1"
    secret_key                  = "21172b38fe830d52d13593487c4b735b16d9026e75a20f47"
  }
}

# Terraform for IBM provide (REQUIRED)
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}

# Configure the IBM Provider (REQUIRED)
provider "ibm" {
  region = "us-south"
}

# Create code engine project
data "ibm_resource_group" "group" {
  name = "Terraform-RG"
}

resource "ibm_code_engine_project" "project_name" {
  name              = "terraform-project-dev2"
  resource_group_id = data.ibm_resource_group.group.id

  lifecycle {
    prevent_destroy = true
    ignore_changes = all

  }

}

resource "ibm_code_engine_secret" "secrets" {
  project_id = ibm_code_engine_project.project_name.project_id
  name = "my-secret"
  format = "generic"

  data = {
        kibana_password   = var.kibana_password
        elastic_password  = var.elastic_password
        database_password = var.database_password
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = all

  }
}


resource "ibm_code_engine_secret" "registry" {
  project_id = ibm_code_engine_project.project_name.project_id
  name = "ibmcloud-cr"
  format = "registry"

  data = {
        server    = "us.icr.io"
        username  = "iamapikey"
        password  = "ese_serfn_ddd"
        email     = "abc@gmail.com"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = all

  }
}


resource "ibm_code_engine_app" "code_engine_app" {
  project_id      = ibm_code_engine_project.project_name.project_id
  name            = "terraform-ibmcloud-dev"
  image_reference = "icr.io/codeengine/helloworld"
  image_secret = ibm_code_engine_secret.registry.name
  
  run_env_variables {
    type  = "literal"
    name  = "ENVIRONMENT"
    value = "Dev"
  }
  
  run_env_variables {
    type  = "literal"
    name  = "USERNAME"
    value = "user-2"
  }

  run_env_variables {
    type  = "literal"
    name  = "sql_server_ip"
    value = "100.100.100.100"
  }

  run_env_variables {
    type  = "literal"
    name  = "DISABLED_COS"
    value = "True"
  }

  run_env_variables {
    type  = "secret_full_reference"
    reference = "my-secret" 
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = all 

  }
}


