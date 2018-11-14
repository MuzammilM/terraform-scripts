variable "ssh_key" {
  description = "Test SSH Keys"
  default     = "~/.ssh/id_rsa.pub"
}

variable "count" {}

variable "region" {
	description = "Region to use for setting up this project"
	default = "ap-south"
}

variable "root_pass" {}

variable "projectName" {
	description = "Name of the project"
	default = "Mosquitto"
}
