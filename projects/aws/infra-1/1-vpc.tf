#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = local.network.vpc_cidr
  tags = {
    Name = "${local.project.name}-vpc"
  }
}