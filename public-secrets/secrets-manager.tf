resource "aws_secretsmanager_secret" "secret" {
  name = "${var.secrets_manager_name}/${var.secrets_manager_name_suffix}"
}


resource "aws_secretsmanager_secret_version" "secret" {
  secret_id = aws_secretsmanager_secret.secret.id
  secret_string = <<EOF
{
  "dlrftpuser": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/dlrftpuser\"}]",
    "Password": "dlr2015Bqa",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "dskftpuser": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/dskftpuser\"}]",
    "Password": "94zp7nab",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "eddftpuser": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/eddftpuser\"}]",
    "Password": "edd123x",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "nceftpuser": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/nceftpuser\"}]",
    "Password": "U2rL84mE",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "ndg": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/ndg\"}]",
    "Password": "4go6d",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "vitalii_test": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/vitalii_test\"}]",
    "Password": "5pecial5",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "siarhei_test": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/siarhei_test\"}]",
    "Password": "1shya2",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  },
  "well": {
    "HomeDirectoryDetails": "[{\"Entry\": \"/\", \"Target\": \"/sftp.home.url/DeskSOA/well\"}]",
    "PublicKey": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmJ5dcE3nK32jpRGfOihIEN6fHKUAnvNWRUYwwL5Zmu+5cmEaobuAGae9aOCDu88jI8zKe1RMPYudtt6hsHEIwYsipCWv6+VZj6lhfVM9tcSQIcZHsb/LSPeZVt6R9dWCeXf+8XGLEwc4Tij1fCwOPAanmbHwblgbgLx3Ll7ZLKXQV2kW27qT0k1E5HVgQzIYw8qQ6X4ZPu/s58RdjHpeXD7s1BGj/T9G1W3LcOHCmnZDi2DhZFX7avU0qZ6p9pMYE3L2fhd5BQnJ0WI6di2sKTTjhPNm4MmSWbGznjDueVVXrParL35Pp+rg8MAdK/XGDWFOmBtWqCz+fJZyWmMVAKSBQTXJUf8mUihJuJWK1gWD+lLLkdOUGmfKX1UIbskF8vidOG4LF5u+TfZZIofmyGpmuYfXfnLL3o1517Y0f7xZL8oYA6cHZ4HoDSi1oco4nuxzHBY9BR3Mek3mCxw0V1FzfMBfPEurGn1eiGt0a6vyQn6Qdj6BWlxKTngzaCgs= well@bot",
    "Password": "",
    "Role": "arn:aws:iam::${local.account_id}:role/acct-managed/${alks_iamrole.transfer-server-iam-role.name}"
  }
}
EOF
}