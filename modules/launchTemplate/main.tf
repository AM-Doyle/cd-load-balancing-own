resource "aws_launch_template" "custom_launch_template" {

    count = length(var.ami_ids)

  name = "lt_sh_${count.index + 1}"

  instance_type          = var.instance_type
  
  image_id = var.ami_ids[count.index]

  key_name = "tfIntroKey"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet_ids[count.index]
    security_groups = var.security_group_ids

  }

}