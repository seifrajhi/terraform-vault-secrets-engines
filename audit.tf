resource "vault_audit" "file" {
  type = "file"
  path = "file"

  options = {
    file_path = var.vault_audit_file_path
  }
}
