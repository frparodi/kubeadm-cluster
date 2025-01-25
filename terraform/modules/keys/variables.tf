variable "key_name" {
  type        = string
  description = "SSH Key Name"
}

variable "store_local_private_key" {
  type    = bool
  default = false
}
