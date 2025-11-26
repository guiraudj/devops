output "instance_ids" {
  description = "IDs of all EC2 instances"
  value       = [for i in module.sample_app : i.aws_instance.sample_app.id]
}

output "public_ips" {
  description = "Public IPs of all EC2 instances"
  value       = [for i in module.sample_app : i.aws_instance.sample_app.public_ip]
}
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.sample_app.id
}


