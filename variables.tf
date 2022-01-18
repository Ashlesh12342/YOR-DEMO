variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.0.0/24"
}

variable "public_subnet2_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "ami" {
  description = "Ubuntu Server 18.04 LTS"
  default = "ami-0742b4e673072066f"
}

variable "ecs_cluster" {
  description = "ECS cluster name"
  default="themuskecscluster"
}





