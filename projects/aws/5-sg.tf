#Create security group for frontend load balancer (frontend-lb)
resource "aws_security_group" "frontend_lb" {
  vpc_id = aws_vpc.vpc.id
  name = "${local.project.name}-frontend-lb-sg"
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

#Create ingress rules to frontend-lb 
#from internet
resource "aws_security_group_rule" "ingress_frontend_lb_http_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.frontend_lb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#Create egress rules from frontend loadbalancer
#to frontend http only
resource "aws_security_group_rule" "egress_frontend_lb_traffic" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_lb.id
  source_security_group_id = aws_security_group.frontend.id
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

#Create ingress rules to frontend
#from frontend-lb http only
resource "aws_security_group_rule" "ingress_frontend_http_traffic" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend.id
  source_security_group_id = aws_security_group.frontend_lb.id
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

#to backend
resource "aws_security_group_rule" "egress_frontend_to_backend_traffic" {
  type                      = "egress"
  from_port                 = 8080
  to_port                   = 8080
  protocol                  = "tcp"
  security_group_id         = aws_security_group.frontend.id
  source_security_group_id  = aws_security_group.backend.id
}

#Create ingress rules to backend
#from frontend http only
resource "aws_security_group_rule" "ingress_backend_from_frontend_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.backend.id
  source_security_group_id = aws_security_group.frontend.id
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