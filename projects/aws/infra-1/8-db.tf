resource "aws_db_instance" "db" {
  allocated_storage = 10
  engine = "mysql"
  instance_class = "db.t3.micro"
  identifier = "${local.project.name}-db"
  db_name = local.db.name
  username = local.db.username
  password = local.db.password
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnets.name
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "db_subnets" {
  name = "db-subnet-group"
  subnet_ids = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]

  tags = {
    Name = "DB Subnets"
  }
}