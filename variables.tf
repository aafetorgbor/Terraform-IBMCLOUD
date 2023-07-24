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
