data "dns_a_record_set" "db" {
  host = "${aws_db_instance.db.address}"
}

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

output "database_private_ip" {
  value = join(",", data.dns_a_record_set.db.addrs)
}

resource "local_file" "hostfile" {
  filename = "etc/hosts"
  content = <<-CONTENT
    127.0.0.1 localhost
    ${aws_instance.frontend.private_ip} frontend
    ${aws_instance.backend.private_ip} backend
    ${join(",", data.dns_a_record_set.db.addrs)} db
    CONTENT
}