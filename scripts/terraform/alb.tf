resource "aws_lb" "helloworld-alb" {
  name = "helloworld-alb"
  internal = true
  load_balancer_type = "application"
  subnets = [ aws_subnet.public_us-east-2a.id, aws_subnet.public_us-east-2b.id, aws_subnet.public_us-east-2c.id ]
  security_groups = [ aws_security_group.https-in-anywhere.id, aws_security_group.icmp-in-out-anywhere.id, aws_security_group.all-out-anywhere.id ]

  tags = {
    Name = "helloworld-alb"
  }
}

resource "aws_lb_target_group" "alb-target-group" {
  name = "alb-target-group"
  port = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = aws_vpc.helloworld_vpc.id
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.helloworld-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}
