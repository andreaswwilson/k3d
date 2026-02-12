variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "tls_cert_path" {
  type = string
}

variable "tls_key_path" {
  type = string
}
