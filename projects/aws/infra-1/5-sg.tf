#Create security group for frontend load balancer (lb)
resource "aws_security_group" "lb" {
  vpc_id = aws_vpc.vpc.id
  name = "${local.project.name}-lb-sg"
}

#Create security group for admin servers
resource "aws_security_group" "admin" {
  vpc_id = aws_vpc.vpc.id
  name   = "${local.project.name}-admin-sg"
}

#Create security group for frontend servers
resource "aws_security_group" "frontend" {
  vpc_id = aws_vpc.vpc.id
  name   = "${local.project.name}-frontend-sg"
}

#Create security group for backend servers
resource "aws_security_group" "backend" {
  vpc_id = aws_vpc.vpc.id
  name   = "${local.project.name}-backend-sg"
}

#Create security group for rds
resource "aws_security_group" "db" {
  vpc_id = aws_vpc.vpc.id
  name   = "${local.project.name}-db-sg"
}

#Create ingress rules to lb 
#from internet
resource "aws_security_group_rule" "ingress_lb_http_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

###CHECK THIS
#from frontend
resource "aws_security_group_rule" "ingress_lb_frontend_traffic" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
#  source_security_group_id = aws_security_group.frontend.id
}

#Create egress rules from frontend loadbalancer
#to frontend http only
resource "aws_security_group_rule" "egress_lb_frontend_traffic" {
  type                     = "egress"
  from_port                = 3030
  to_port                  = 3030
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.frontend.id
}

#to backend-lb http only
resource "aws_security_group_rule" "egress_lb_backend_traffic" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = aws_security_group.backend.id
}

#Create ingress rules to admin 
#from internet
resource "aws_security_group_rule" "ingress_admin_ssh_traffic" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.admin.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#from private network
resource "aws_security_group_rule" "ingress_admin_private_traffic" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.admin.id
  cidr_blocks       = [local.network.vpc_cidr]
}

#Create egress rules from admin
#to internet
resource "aws_security_group_rule" "egress_admin_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.admin.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#to frontend
resource "aws_security_group_rule" "egress_admin_ssh_to_frontend_traffic" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.admin.id
  source_security_group_id = aws_security_group.frontend.id
}

#to backend
resource "aws_security_group_rule" "egress_admin_ssh_to_backend_traffic" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.admin.id
  source_security_group_id = aws_security_group.backend.id
}

#to db
resource "aws_security_group_rule" "egress_admin_to_db_traffic" {
  type              = "egress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.admin.id
  source_security_group_id = aws_security_group.db.id
}

#Create ingress rules to frontend
#from frontend-lb http only
resource "aws_security_group_rule" "ingress_frontend_http_traffic" {
  type                     = "ingress"
  from_port                = 3030
  to_port                  = 3030
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  source_security_group_id = aws_security_group.lb.id
}

#from admin-sg ssh only
resource "aws_security_group_rule" "ingress_frontend_ssh_traffic" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  source_security_group_id = aws_security_group.admin.id
}

#Create egress rules from frontend
#to internet from nat gateway in admin
resource "aws_security_group_rule" "egress_frontend_to_internet_traffic" {
  type                      = "egress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  security_group_id         = aws_security_group.frontend.id
  cidr_blocks               = ["0.0.0.0/0"]
}

####CHECK THIS
#to backend-lb
resource "aws_security_group_rule" "egress_frontend_to_lb_traffic" {
  type                      = "egress"
  from_port                 = 3000
  to_port                   = 3000
  protocol                  = "tcp"
  security_group_id         = aws_security_group.frontend.id
  source_security_group_id  = aws_security_group.lb.id
}

#Create ingress rules to backend
#from backend-lb http only
resource "aws_security_group_rule" "ingress_backend_from_lb_traffic" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  source_security_group_id = aws_security_group.lb.id
}

#from admin-sg ssh only
resource "aws_security_group_rule" "ingress_backend_ssh_traffic" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  source_security_group_id = aws_security_group.admin.id
}

#Create egress rules from backend
#to internet from nat gateway in admin
resource "aws_security_group_rule" "egress_backend_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.backend.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#Create ingress rules to db
#from backend sql only
resource "aws_security_group_rule" "ingress_db_from_backend_traffic" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.backend.id
}

#from admin-sg ssh only
resource "aws_security_group_rule" "ingress_db_from_admin_traffic" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db.id
  source_security_group_id = aws_security_group.admin.id
}