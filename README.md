# terraform-vault-okta

Terraform configuration to configure Vault with different secrets engines.

## Usage

```
module "engines" {
  source  = "https://github.com/seifrajhi/terraform-vault-engines"

  kv_backends = [
    {
      path                      = "kv"
      version                   = 2
      description               = "Key-Value Secrets Engine"
      default_lease_ttl_seconds = 3600
    }
    # Add more kv_backends as needed
  ]

  transit_secret_backend_enabled = true

  rabbitmq_backends = [
    {
      credential_path = "rabbitmq/creds/my-role"
      connection_uri  = "amqp://guest:guest@localhost:5672/"
    }
    # Add more rabbitmq_backends as needed
  ]

  database_secret_backend_enabled = true

  database_mount_path             = "mydb"
  database_lease_duration_seconds = 600

  database_mysql_legacy_connections = {
    my_legacy_db = {
      backend                 = "mysql"
      allowed_roles           = ["readonly"]
      connection_url_path     = "mysql_legacy/creds/readonly"
      max_open_connections    = 10
      max_idle_connections    = 2
      max_connection_lifetime = "1h"
    }
    # Add more database_mysql_legacy_connections as needed
  }

  database_mysql_connections = {
    my_mysql_db = {
      backend                 = "mysql"
      allowed_roles           = ["readwrite"]
      connection_url_path     = "mysql/creds/readwrite"
      max_open_connections    = 10
      max_idle_connections    = 2
      max_connection_lifetime = "1h"
    }
    # Add more database_mysql_connections as needed
  }

  database_aurora_connections = {
    my_aurora_db = {
      backend                 = "aurora"
      allowed_roles           = ["admin"]
      connection_url_path     = "aurora/creds/admin"
      max_open_connections    = 10
      max_idle_connections    = 2
      max_connection_lifetime = "1h"
    }
    # Add more database_aurora_connections as needed
  }

  database_postgresql_connections = {
    my_postgresql_db = {
      backend                 = "postgresql"
      allowed_roles           = ["superuser"]
      connection_url_path     = "postgresql/creds/superuser"
      max_open_connections    = 10
      max_idle_connections    = 2
      max_connection_lifetime = "1h"
    }
    # Add more database_postgresql_connections as needed
  }

  pki_backends = {
    my_pki_backend = {
      intermediate_common_name = "my-intermediate-ca"
    }
    # Add more pki_backends as needed
  }

  aws_backends = {
    my_aws_backend = {
      credential_path = "aws/creds/my-role"
      region          = "eu-west-1"
    }
    # Add more aws_backends as needed
  }
}

```


<!-- DOC_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 2.1.2 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_audit.file](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/audit) | resource |
| [vault_aws_secret_backend.aws](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/aws_secret_backend) | resource |
| [vault_database_secret_backend_connection.aurora](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/database_secret_backend_connection) | resource |
| [vault_database_secret_backend_connection.mysql_legacy](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/database_secret_backend_connection) | resource |
| [vault_database_secret_backend_connection.mysql_modern](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/database_secret_backend_connection) | resource |
| [vault_database_secret_backend_connection.postgresql](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/database_secret_backend_connection) | resource |
| [vault_mount.database](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/mount) | resource |
| [vault_mount.kv](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/mount) | resource |
| [vault_mount.pki](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/mount) | resource |
| [vault_mount.transit](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/mount) | resource |
| [vault_pki_secret_backend_intermediate_cert_request.intermediate](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/pki_secret_backend_intermediate_cert_request) | resource |
| [vault_pki_secret_backend_intermediate_set_signed.intermediate](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/pki_secret_backend_intermediate_set_signed) | resource |
| [vault_pki_secret_backend_root_sign_intermediate.root](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/pki_secret_backend_root_sign_intermediate) | resource |
| [vault_rabbitmq_secret_backend.rabbitmq](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/resources/rabbitmq_secret_backend) | resource |
| [vault_generic_secret.aurora](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.aws](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.mysql](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.mysql_legacy](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.postgresql](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.rabbitmq](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.vault-token](https://registry.terraform.io/providers/hashicorp/vault/3.5.0/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_backends"></a> [aws\_backends](#input\_aws\_backends) | n/a | `map(any)` | `{}` | no |
| <a name="input_database_aurora_connections"></a> [database\_aurora\_connections](#input\_database\_aurora\_connections) | n/a | `map(any)` | `{}` | no |
| <a name="input_database_lease_duration_seconds"></a> [database\_lease\_duration\_seconds](#input\_database\_lease\_duration\_seconds) | Lease duration of database leases in seconds | `string` | `"1209600"` | no |
| <a name="input_database_mount_path"></a> [database\_mount\_path](#input\_database\_mount\_path) | n/a | `string` | `""` | no |
| <a name="input_database_mysql_connections"></a> [database\_mysql\_connections](#input\_database\_mysql\_connections) | n/a | `map(any)` | `{}` | no |
| <a name="input_database_mysql_legacy_connections"></a> [database\_mysql\_legacy\_connections](#input\_database\_mysql\_legacy\_connections) | n/a | `map(any)` | `{}` | no |
| <a name="input_database_postgresql_connections"></a> [database\_postgresql\_connections](#input\_database\_postgresql\_connections) | n/a | `map(any)` | `{}` | no |
| <a name="input_database_secret_backend_enabled"></a> [database\_secret\_backend\_enabled](#input\_database\_secret\_backend\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_kv_backends"></a> [kv\_backends](#input\_kv\_backends) | n/a | `map(any)` | `{}` | no |
| <a name="input_pki_backends"></a> [pki\_backends](#input\_pki\_backends) | n/a | `map(any)` | `{}` | no |
| <a name="input_rabbitmq_backends"></a> [rabbitmq\_backends](#input\_rabbitmq\_backends) | ################## Secret Backends # ################## | `map(any)` | `{}` | no |
| <a name="input_transit_mount_path"></a> [transit\_mount\_path](#input\_transit\_mount\_path) | n/a | `string` | `"transit"` | no |
| <a name="input_transit_secret_backend_enabled"></a> [transit\_secret\_backend\_enabled](#input\_transit\_secret\_backend\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_vault_address"></a> [vault\_address](#input\_vault\_address) | The http(s) URL of vault server | `string` | n/a | yes |
| <a name="input_vault_audit_file_path"></a> [vault\_audit\_file\_path](#input\_vault\_audit\_file\_path) | ######## Audit # ######## | `string` | `"stdout"` | no |
| <a name="input_vault_token_path"></a> [vault\_token\_path](#input\_vault\_token\_path) | The path to the vault token, should be stored in the  vault | `string` | n/a | yes |

## Outputs

No outputs.
