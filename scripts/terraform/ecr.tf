resource "aws_ecr_repository" "terraform_container_repo" {
  name = "terraform_container_repo"
  force_delete = true
}