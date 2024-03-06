variable "ami_ids" {
  type = list(string)
}
variable "instance_type" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}