variable "lt_ids" {
  type = list(string)
}

variable "min_instances" {
    type = number
}
variable "desired_instances" {
    type = number
}
variable "max_instances" {
    type = number
}

variable "target_groups_map" {
  
}
variable "target_groups_keys" {
  
}

variable "availability_zones" {
  type = list(string)
}