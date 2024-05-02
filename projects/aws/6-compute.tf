#Create front-end instances
resource "aws_instance" "frontend" {
  instance_type = local.ec2.frontend.machine_type
  ami           = local.ec2.frontend.ami
  subnet_id    = aws_subnet.private_az1.id
  vpc_security_group_ids  = [aws_security_group.frontend.id]
  associate_public_ip_address = false
  key_name     = "terraform"
  user_data     = local.ec2.frontend.user_data
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
  user_data     = local.ec2.backend.user_data
  tags = {
    Name = "${local.project.name}-backend"
    }
}

resource "aws_instance" "jumpbox" {
  instance_type = local.ec2.jumpbox.machine_type
  ami           = local.ec2.jumpbox.ami
  subnet_id    = aws_subnet.public_az1.id
  vpc_security_group_ids  = [aws_security_group.admin.id]
  key_name     = "terraform"
  associate_public_ip_address = true 
  user_data     = local.ec2.jumpbox.user_data
  provisioner "file" {
    source      = "~/.ssh/dev_aws_terraform"
    destination = ".ssh/terraform"
  }
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("~/.ssh/dev_aws_terraform")
    host        = self.public_ip
  }
  tags = {
    Name = "${local.project.name}-jumpbox"
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
  user_data     = local.ec2.gateway.user_data
  tags = {
    Name = "${local.project.name}-gateway"
    }
}
