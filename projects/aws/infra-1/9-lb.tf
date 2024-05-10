#Frontend LB
resource "aws_lb_target_group" "frontend" {
  name       = "frontend"
  port       = 3030
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0
  load_balancing_algorithm_type = "round_robin"
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  health_check {
    enabled             = true
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    timeout             = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "frontend" {
    target_group_arn = aws_lb_target_group.frontend.arn
    target_id        = aws_instance.frontend.id
    port             = 3030
}

#Backend LB
resource "aws_lb_target_group" "backend" {
  name       = "backend"
  port       = 3000
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  slow_start = 0
  load_balancing_algorithm_type = "round_robin"
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  health_check {
    enabled             = true
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    timeout             = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "backend" {
    target_group_arn = aws_lb_target_group.backend.arn
    target_id        = aws_instance.backend.id
    port             = 3000
}

resource "aws_lb_listener" "frontend-lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener" "backend-lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb" "lb" {
  name               = "${local.project.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id,
    aws_subnet.public_az3.id
  ]
}