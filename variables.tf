variable "kibana_password" {
  description = "Kibana password"
  type        = string
  default = "${kibana_password}"
  sensitive   = true
}

variable "elastic_password" {
  description = "Elastic password"
  type        = string
  default = "${elastic_password}"
  sensitive   = true
}

variable "database_password" {
  description = "Database password-new"
  type        = string
  default = "${database_password}"
  sensitive   = true
}

variable "access_key" {
  description = "Remote state file access key"
  type        = string
  default = "${access_key}"
  sensitive   = true
}

variable "secret_key_key" {
  description = "Remote state file secret key"
  type        = string
  default = "${secret_key}"
  sensitive   = true
}

