resource "aws_ecs_service" "helloworld-service" {
  name = "helloworld-service"
  cluster = aws_ecs_cluster.helloworld-cluster.id
  task_definition = aws_ecs_task_definition.helloworld-td.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets = [ aws_subnet.public_us-east-2a.id, aws_subnet.public_us-east-2b.id, aws_subnet.public_us-east-2c.id ]
    security_groups = [ aws_security_group.https-in-anywhere.id, aws_security_group.icmp-in-out-anywhere.id, aws_security_group.all-out-anywhere.id ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nlb-target-group.arn
    container_name = "helloworld-container"
    container_port = 8080
  }
}