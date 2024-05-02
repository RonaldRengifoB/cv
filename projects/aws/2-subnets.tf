#Create Public Subnets
resource "aws_subnet" "public_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.public_az1_cidr
  availability_zone = "${local.provider.region}a"
  tags = {
    Name = "${local.project.name}-public-subnet-az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.public_az2_cidr
  availability_zone = "${local.provider.region}b"
  tags = {
    Name = "${local.project.name}-public-subnet-az2"
  }
}

resource "aws_subnet" "public_az3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.public_az3_cidr
  availability_zone = "${local.provider.region}c"
  tags = {
    Name = "${local.project.name}-public-subnet-az3"
  }
}

#Create Private Subnets
resource "aws_subnet" "private_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.private_az1_cidr
  availability_zone = "${local.provider.region}a"
  tags = {
    Name = "${local.project.name}-private-subnet-az1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.private_az2_cidr
  availability_zone = "${local.provider.region}b"
  tags = {
    Name = "${local.project.name}-private-subnet-az2"
  }
}

resource "aws_subnet" "private_az3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.network.private_az3_cidr
  availability_zone = "${local.provider.region}c"
  tags = {
    Name = "${local.project.name}-private-subnet-az3"
  }
}