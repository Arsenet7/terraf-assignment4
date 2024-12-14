variable "keypair_name" {
  description = "The name of the key pair to use for EC2 instances"
  type        = string
  default     = "ebskey"
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instances"
  type        = string
  default     = "ami-036841078a4b68e14"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "kmer-vpc"
}

variable "public_subnet_name" {
  description = "Name for the public subnet"
  type        = string
  default     = "douala"
}

variable "private_subnet_name" {
  description = "Name for the private subnet"
  type        = string
  default     = "yaounde"
}
