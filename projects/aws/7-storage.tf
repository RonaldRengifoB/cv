#Create front-end instances
resource "aws_ebs_volume" "gateway" {
  availability_zone = aws_instance.gateway.availability_zone
  size              = 8
  tags = {
    Name = "${local.project.name}-gateway-ebs"
  }
}

resource "aws_volume_attachment" "gateway" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.gateway.id
  instance_id = aws_instance.gateway.id
}
