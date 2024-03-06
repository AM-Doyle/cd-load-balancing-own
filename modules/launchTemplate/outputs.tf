output "lt_ids" {
  value = aws_launch_template.custom_launch_template[*].id
}