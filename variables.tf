
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "availability_zones_euw" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "privare_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_cidr" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "ec2_count" {
  type    = number
  default = 3
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "tfIntroKey"
}

variable "ami_id" {
  type    = string
  default = "ami-0505148b3591e4c07"
}