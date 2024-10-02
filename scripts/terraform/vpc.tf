resource "aws_vpc" "helloworld_vpc" {
  tags = {
    Name = "vpc-terraform"
  }
  cidr_block = "172.32.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}