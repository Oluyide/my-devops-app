variable "app_name" {
  description = "Name used for tagging and resource naming."
  type        = string
  default     = "my-devops-app"
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH (port 22). Set to your IP, e.g. 1.2.3.4/32."
  type        = string
  default     = "0.0.0.0/0"
}

variable "app_port" {
  description = "Port the app listens on (must match server.js / Docker)."
  type        = number
  default     = 3000
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH. Leave null to skip key assignment."
  type        = string
  default     = null
}