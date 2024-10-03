resource "aws_security_group" "https-in-anywhere" {
  name = "https-in-anywhere"
  description = "Allows HTTP(s) in from anywhere"
  vpc_id = aws_vpc.helloworld_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "http-allow-in" {
  security_group_id = aws_security_group.https-in-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https-allow-in" {
  security_group_id = aws_security_group.https-in-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  to_port = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http-allow-in-8080" {
  security_group_id = aws_security_group.https-in-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
}

resource "aws_security_group" "all-out-anywhere" {
  name = "all-out-anywhere"
  vpc_id = aws_vpc.helloworld_vpc.id
}

resource "aws_vpc_security_group_egress_rule" "all-traffic-out" {
  security_group_id = aws_security_group.all-out-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "icmp-in-out-anywhere" {
  name = "icmp-in-out-anywhere"
  vpc_id = aws_vpc.helloworld_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "icmp-allow-in" {
  security_group_id = aws_security_group.icmp-in-out-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1
  to_port = -1
  ip_protocol = "icmp"
}

resource "aws_vpc_security_group_egress_rule" "icmp-allow-out" {
  security_group_id = aws_security_group.icmp-in-out-anywhere.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1
  to_port = -1
  ip_protocol = "icmp"
}