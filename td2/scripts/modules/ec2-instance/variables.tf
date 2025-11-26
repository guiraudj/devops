variable "ami_id" {
  description = "The ID of the AMI to run."
  type        = string
}

variable "name" { 
  description = "The base name for the instance and all other resources"
  type        = string
}

variable "port" {
  description = "The port on which the EC2 instance will allow HTTP traffic"
  type        = number
  default     = 8080
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2
}