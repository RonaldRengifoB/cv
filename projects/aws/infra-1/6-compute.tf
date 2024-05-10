#Create front-end instances
resource "aws_instance" "frontend" {
  instance_type = local.ec2.frontend.machine_type
  ami           = local.ec2.frontend.ami
  subnet_id    = aws_subnet.private_az1.id
  vpc_security_group_ids  = [aws_security_group.frontend.id]
  associate_public_ip_address = false
  key_name     = "terraform"
  tags = {
    Name = "${local.project.name}-frontend"
    }
}

resource "aws_instance" "backend" {
  instance_type = local.ec2.backend.machine_type
  ami           = local.ec2.backend.ami
  subnet_id    = aws_subnet.private_az1.id
  vpc_security_group_ids  = [aws_security_group.backend.id]
  associate_public_ip_address = false
  key_name     = "terraform"
  tags = {
    Name = "${local.project.name}-backend"
    }
}

resource "aws_instance" "gateway" {
  instance_type = local.ec2.gateway.machine_type
  ami           = local.ec2.gateway.ami
  subnet_id    = aws_subnet.public_az1.id
  vpc_security_group_ids  = [aws_security_group.admin.id]
  key_name     = "terraform"
  source_dest_check = false
  associate_public_ip_address = true 
  tags = {
    Name = "${local.project.name}-gateway"
    }
}

resource "aws_instance" "jumpbox" {
  instance_type = local.ec2.jumpbox.machine_type
  ami           = local.ec2.jumpbox.ami
  subnet_id    = aws_subnet.public_az1.id
  vpc_security_group_ids  = [aws_security_group.admin.id]
  key_name     = "terraform"
  associate_public_ip_address = true 
  user_data     = data.cloudinit_config.jumpbox_config.rendered
  tags = {
    Name = "${local.project.name}-jumpbox"
    }
}

resource "null_resource" "provision_jumpbox" {
  provisioner "local-exec" {
    command = <<-EOT
              scp -i ~/.ssh/dev_aws_terraform -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r .ansible admin@${aws_instance.jumpbox.public_ip}:~/.ansible
              sleep 10
              scp -i ~/.ssh/dev_aws_terraform -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r app admin@${aws_instance.jumpbox.public_ip}:~/app
              sleep 10
              scp -i ~/.ssh/dev_aws_terraform -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null db/.my.cnf db/db.sql inventory configure_servers-playbook.yml admin@${aws_instance.jumpbox.public_ip}:~
              sleep 10
              scp -i ~/.ssh/dev_aws_terraform -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null .ssh/config admin@${aws_instance.jumpbox.public_ip}:~/.ssh/config
              sleep 10
              scp -i ~/.ssh/dev_aws_terraform -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ~/.ssh/dev_aws_terraform admin@${aws_instance.jumpbox.public_ip}:~/.ssh/terraform
              sleep 10
              EOT
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0400 .ssh/terraform",
      "ssh-keyscan -H ${aws_instance.frontend.private_ip} >> /home/admin/.ssh/known_hosts",
      "ssh-keyscan -H ${aws_instance.backend.private_ip} >> /home/admin/.ssh/known_hosts",
      "mysql --defaults-file=/home/admin/.my.cnf -h ${join(",", data.dns_a_record_set.db.addrs)} -P 3306 < db.sql",
    ]
  }

  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("~/.ssh/dev_aws_terraform")
    host        = aws_instance.jumpbox.public_ip
  }
}