resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_lb" "helloworld-nlb" {
  name = "helloworld-nlb"
  internal = false
  load_balancer_type = "network"
  security_groups = [ aws_security_group.https-in-anywhere.id, aws_security_group.icmp-in-out-anywhere.id, aws_security_group.all-out-anywhere.id ]

  subnet_mapping {
    subnet_id = aws_subnet.public_us-east-2a.id
    allocation_id = aws_eip.eip.id
  }
}

resource "aws_lb_target_group" "nlb-target-group" {
  name = "nlb-target-group"
  port = 8080
  protocol = "TCP"
  vpc_id = aws_vpc.helloworld_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "nlb-listener" {
  load_balancer_arn = aws_lb.helloworld-nlb.arn
  port = 80
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb-target-group.arn
  }
}
