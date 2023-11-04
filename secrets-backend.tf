#
# KV Backends
#
resource "vault_mount" "kv" {
  for_each = var.kv_backends

  path                      = each.value.path
  type                      = lookup(each.value, "type", "kv")
  description               = lookup(each.value, "description", "")
  default_lease_ttl_seconds = lookup(each.value, "default_lease_ttl_seconds", null)

  options = {
    version = each.value.version
  }
}

#
# Transit
#
resource "vault_mount" "transit" {
  count = var.transit_secret_backend_enabled ? 1 : 0

  path = var.transit_mount_path
  type = "transit"

}

#
# RabbitMQ Backends
#

data "vault_generic_secret" "rabbitmq" {
  

  for_each = var.rabbitmq_backends

  path = each.value.credential_path
}

resource "vault_rabbitmq_secret_backend" "rabbitmq" {
  for_each = var.rabbitmq_backends

  connection_uri = each.value.connection_uri
  path           = each.value.path
  username       = data.vault_generic_secret.rabbitmq[each.key].data["username"]
  password       = data.vault_generic_secret.rabbitmq[each.key].data["password"]
  default_lease_ttl_seconds = lookup(each.value, "default_lease_ttl_seconds", null)
  max_lease_ttl_seconds = lookup(each.value, "max_lease_ttl_seconds", null)

  lifecycle {
    ignore_changes = [
      description
    ]
  }
}

#
# Database
#
resource "vault_mount" "database" {
  count = var.database_secret_backend_enabled ? 1 : 0

  path                      = replace(var.database_mount_path, "/", "")
  default_lease_ttl_seconds = var.database_lease_duration_seconds
  type                      = "database"
}

data "vault_generic_secret" "mysql_legacy" {
  

  for_each = var.database_mysql_legacy_connections

  path = each.value.connection_url_path
}

data "vault_generic_secret" "mysql" {
  

  for_each = var.database_mysql_connections

  path = each.value.connection_url_path
}

data "vault_generic_secret" "aurora" {
  

  for_each = var.database_aurora_connections

  path = each.value.connection_url_path
}

data "vault_generic_secret" "postgresql" {
  

  for_each = var.database_postgresql_connections

  path = each.value.connection_url_path
}

resource "vault_database_secret_backend_connection" "mysql_legacy" {
  for_each = var.database_mysql_legacy_connections

  name          = each.key
  backend       = each.value.backend
  allowed_roles = lookup(each.value, "allowed_roles", ["*"])

  mysql_legacy {
    connection_url          = sensitive(data.vault_generic_secret.mysql_legacy[each.key].data["connection_url"])
    max_open_connections    = lookup(each.value, "max_open_connections", null)
    max_idle_connections    = lookup(each.value, "max_idle_connections", null)
    max_connection_lifetime = lookup(each.value, "max_connection_lifetime", null)

  }

  depends_on = [
    vault_mount.database
  ]
}

resource "vault_database_secret_backend_connection" "mysql_modern" {
  for_each = var.database_mysql_connections
  name          = each.key
  backend       = each.value.backend
  allowed_roles = lookup(each.value, "allowed_roles", ["*"])

  mysql {
    connection_url          = sensitive(data.vault_generic_secret.mysql[each.key].data["connection_url"])
    max_open_connections    = lookup(each.value, "max_open_connections", null)
    max_idle_connections    = lookup(each.value, "max_idle_connections", null)
    max_connection_lifetime = lookup(each.value, "max_connection_lifetime", null)

  }

  depends_on = [
    vault_mount.database
  ]
}

resource "vault_database_secret_backend_connection" "aurora" {
  for_each = var.database_aurora_connections
  name          = each.key
  backend       = each.value.backend
  allowed_roles = lookup(each.value, "allowed_roles", ["*"])

  mysql_aurora {
    connection_url          = sensitive(data.vault_generic_secret.aurora[each.key].data["connection_url"])
    max_open_connections    = lookup(each.value, "max_open_connections", null)
    max_idle_connections    = lookup(each.value, "max_idle_connections", null)
    max_connection_lifetime = lookup(each.value, "max_connection_lifetime", null)

  }

  depends_on = [
    vault_mount.database
  ]
}

resource "vault_database_secret_backend_connection" "postgresql" {
  for_each = var.database_postgresql_connections

  name          = each.key
  backend       = each.value.backend
  allowed_roles = lookup(each.value, "allowed_roles", ["*"])

  postgresql {
    connection_url          = sensitive(data.vault_generic_secret.postgresql[each.key].data["connection_url"])
    max_open_connections    = lookup(each.value, "max_open_connections", null)
    max_idle_connections    = lookup(each.value, "max_idle_connections", null)
    max_connection_lifetime = lookup(each.value, "max_connection_lifetime", null)
  }
}


#
# PKI
#

resource "vault_mount" "pki" {
  for_each = var.pki_backends

  type = "pki"

  path                      = lookup(each.value, "path", each.key)
  default_lease_ttl_seconds = lookup(each.value, "default_lease_ttl_seconds", null)
  max_lease_ttl_seconds     = lookup(each.value, "default_lease_ttl_seconds", null)
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  for_each = var.pki_backends

  backend = lookup(each.value, "path", each.key)

  type        = "internal"
  common_name = each.value.intermediate_common_name

  depends_on = [vault_mount.pki]
}

resource "vault_pki_secret_backend_root_sign_intermediate" "root" {
  for_each = var.pki_backends

  

  backend = each.value.root_pki_path

  csr         = vault_pki_secret_backend_intermediate_cert_request.intermediate[each.key].csr
  common_name = "Intermediate CA"

  ttl = lookup(each.value, "intermediate_ttl", "87600h")

  depends_on = [vault_pki_secret_backend_intermediate_cert_request.intermediate]
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  for_each = var.pki_backends

  backend = lookup(each.value, "path", each.key)

  certificate = join("\n", [vault_pki_secret_backend_root_sign_intermediate.root[each.key].certificate, vault_pki_secret_backend_root_sign_intermediate.root[each.key].issuing_ca])
}

#
# AWS
#
data "vault_generic_secret" "aws" {
  
  for_each = var.aws_backends
  path = each.value.credential_path
}

resource "vault_aws_secret_backend" "aws" {
  for_each = var.aws_backends

  path                      = each.value.path
  region                    = each.value.region

  access_key = data.vault_generic_secret.aws[each.key].data["access_key"]
  secret_key = data.vault_generic_secret.aws[each.key].data["secret_key"]
}
