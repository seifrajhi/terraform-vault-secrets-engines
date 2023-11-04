#########
# Audit #
#########
variable "vault_audit_file_path" {
  type    = string
  default = "stdout"
}


##############
# Connection #
##############
variable "vault_address" {
  type        = string
  description = "The http(s) URL of vault server"
}

variable "vault_token_path" {
  type        = string
  description = "The path to the vault token, should be stored in the  vault"
}


###################
# Secret Backends #
###################
variable "rabbitmq_backends" {
  type    = map(any)
  default = {}
}

variable "kv_backends" {
  type    = map(any)
  default = {}
}

variable "database_mount_path" {
  type    = string
  default = ""
}

variable "database_lease_duration_seconds" {
  description = "Lease duration of database leases in seconds"
  type        = string
  default     = "1209600"
}

variable "database_postgresql_connections" {
  type    = map(any)
  default = {}
}

variable "database_mysql_legacy_connections" {
  type    = map(any)
  default = {}
}

variable "database_mysql_connections" {
  type    = map(any)
  default = {}
}

variable "database_aurora_connections" {
  type    = map(any)
  default = {}
}

variable "pki_backends" {
  type    = map(any)
  default = {}
}

variable "aws_backends" {
  type    = map(any)
  default = {}
}

variable "transit_mount_path" {
  type    = string
  default = "transit"
}

variable "transit_secret_backend_enabled" {
  type    = bool
  default = false
}

variable "database_secret_backend_enabled" {
  type    = bool
  default = true
}

