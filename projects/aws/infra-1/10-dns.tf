resource "aws_route53_zone" "private_zone" {
  name = "${local.project.name}.net"

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "frontend.${local.project.name}.net"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.frontend.private_ip}"]
}

resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "backend.${local.project.name}.net"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.backend.private_ip}"]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "db.${local.project.name}.net"
  type    = "A"
  ttl     = "300"
  records = ["${join(",", data.dns_a_record_set.db.addrs)}"]
}

resource "aws_route53_record" "lb" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "lb.${local.project.name}.private"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.lb.dns_name}"]
}