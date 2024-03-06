output "DNS_name" {
  value = module.alb.dns_name
}

output "lt_ids" {
  value = module.launch_template.lt_ids
}

output "asg_ids" {
  value = module.auto_scaling_group.asg_id
}
