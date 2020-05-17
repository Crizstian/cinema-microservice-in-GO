variable "enable_infrastructure_policy" {
  default = false
}

resource "vault_policy" "infrastructure-policy" {
  count = var.enable_infrastructure_policy ? 1 : 0

  name   = "provisioner-policy"
  policy = <<EOT
    # Manage auth methods broadly across Vault
    path "auth/*"
    {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }

    # Create, update, and delete auth methods
    path "sys/auth/*"
    {
      capabilities = ["create", "update", "delete", "sudo"]
    }

    # List auth methods
    path "sys/auth"
    {
      capabilities = ["read"]
    }
    # List auth methods
    path "sys/mounts"
    {
      capabilities = ["read"]
    }

    # List existing policies
    path "sys/policies/acl"
    {
      capabilities = ["list"]
    }

    # Create and manage ACL policies via API & UI
    path "sys/policies/acl/*"
    {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }
    
    path "consul/*"
    {
      capabilities = ["create", "read", "update", "delete", "list", "sudo"]
    }

    # List, create, update, and delete key/value secrets
    path "secret/*"
    {
      capabilities = ["create", "read", "update", "delete", "list"]
    }
  EOT
}