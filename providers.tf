terraform {
  required_version = ">= 0.13.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "2.1.2"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = data.vault_generic_secret.vault-token.data["token"]
}


data "vault_generic_secret" "vault-token" {
  provider = vault
  path = var.vault_token_path
}



