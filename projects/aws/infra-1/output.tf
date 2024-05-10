data "dns_a_record_set" "db" {
  host = "${aws_db_instance.db.address}"
}

output "loadbalancer_dns_name" {
  value = "http://${aws_lb.lb.dns_name}"
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

output "jumpbox_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "gateway_public_ip" {
  value = aws_instance.gateway.public_ip
}

resource "local_file" "ansible_backend_vars" {
  filename = ".ansible/roles/backend/defaults/main.yml"
  content = <<-CONTENT
    node_app_path: "{{ ansible_env.HOME }}/app"
    db_host: ${join(",", data.dns_a_record_set.db.addrs)}
    db_user: ${local.db.username}
    db_pass: ${local.db.password}
    db_name: ${local.db.name}
    backend_port: ${local.backend.port}
    CONTENT
}

resource "local_file" "ansible_db_vars" {
  filename = ".ansible/roles/db/defaults/main.yml"
  content = <<-CONTENT
    db_host: ${join(",", data.dns_a_record_set.db.addrs)}
    db_user: ${local.db.username}
    db_pass: ${local.db.password}
    db_name: ${local.db.name}
    CONTENT
}

resource "local_file" "ansible_frontend_vars" {
  filename = ".ansible/roles/frontend/defaults/main.yml"
  content = <<-CONTENT
    node_app_path: "{{ ansible_env.HOME }}/app"
    frontend_port: ${local.frontend.port}
    backend_port: ${local.backend.port}
    backend_url: "${aws_lb.lb.dns_name}:{{ backend_port }}"
    CONTENT
}

resource "local_file" "mysql_cnf" {
  filename = "db/.my.cnf"
  content = <<-CONTENT
    [client]
    user=${local.db.username}
    password=${local.db.password}
    CONTENT
}

resource "local_file" "ansible_inventory" {
  filename = "inventory"
  content = <<-CONTENT
    [frontend]
    ${aws_instance.frontend.private_ip}
    [backend]
    ${aws_instance.backend.private_ip}
    [db]
    ${join(",", data.dns_a_record_set.db.addrs)}
    CONTENT
}