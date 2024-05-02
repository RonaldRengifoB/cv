output "frontend_loadbalancer_dns_name" {
  value = "http://${aws_lb.frontend.dns_name}"
}

output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "gateway_public_ip" {
  value = aws_instance.gateway.public_ip
}

output "frontend_private_ip" {
  value = aws_instance.frontend.private_ip
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}
