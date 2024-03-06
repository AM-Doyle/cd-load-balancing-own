resource "aws_autoscaling_group" "bar" {
    count = length(var.lt_ids)
    name = "smart_home_asi_${count.index}"
  availability_zones = [var.availability_zones[count.index]]
  desired_capacity   = var.desired_instances
  max_size           = var.max_instances
  min_size           = var.min_instances

  launch_template {
    id      = var.lt_ids[count.index]
  }
}

resource "aws_autoscaling_attachment" "example" {
    count = length(var.lt_ids)
  autoscaling_group_name = aws_autoscaling_group.bar[count.index].id
    lb_target_group_arn    = var.target_groups_map[var.target_groups_keys[count.index]].arn
}