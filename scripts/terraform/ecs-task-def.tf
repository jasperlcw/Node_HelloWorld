resource "aws_ecs_task_definition" "helloworld-td" {
  family = "helloworld-td"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512

  execution_role_arn = aws_iam_role.helloworld-role-1.arn
  task_role_arn = aws_iam_role.helloworld-role-1.arn

  container_definitions = jsonencode([
    {
        name = "helloworld-container"
        image = "879381256847.dkr.ecr.us-east-2.amazonaws.com/terraform_container_repo:${var.IMAGE_TAG}"
        portMappings = [
            {
                name = "http-port-8080"
                containerPort = 8080
                hostPort = 8080
                protocol = "tcp"
                appProtocol = "http"
            }
        ]
    }
  ])
}