variable "secret" {
  description = "Ansible vault secret for gitlab repo"
  type        = string
  sensitive   = true
}

variable "secret2" {
  description = "Ansible vault secret for kubespray repo"
  type        = string
  sensitive   = true
}

variable "ssh_private_key" {
  description = "SSH private key"
  type        = string
  sensitive   = true
}