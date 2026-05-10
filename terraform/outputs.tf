output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the security group."
  value       = aws_security_group.web.id
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Public IPv4 of the EC2 instance."
  value       = aws_instance.app.public_ip
}

output "public_dns" {
  description = "Public DNS name of the EC2 instance."
  value       = aws_instance.app.public_dns
}

output "app_url" {
  description = "URL where the app will be reachable once running."
  value       = "http://${aws_instance.app.public_ip}:${var.app_port}"
}

output "ssh_command" {
  description = "Convenience SSH command (requires key_name var)."
  value       = var.key_name == null ? "key_name not set — set var.key_name to enable SSH" : "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.app.public_dns}"
}