output "public_instance_ip" {
  description = "The public IP of the EC2 instance in the public subnet"
  value       = aws_instance.douala.public_ip
}

output "private_instance_ip" {
  description = "The private IP of the EC2 instance in the private subnet"
  value       = aws_instance.yaounde.private_ip
}
