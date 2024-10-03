resource "aws_subnet" "public_us-east-2a" {
  vpc_id = aws_vpc.helloworld_vpc.id
  cidr_block = cidrsubnet(aws_vpc.helloworld_vpc.cidr_block, 8, 1)
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    name = "public-az1"
  }
}

resource "aws_subnet" "public_us-east-2b" {
  vpc_id = aws_vpc.helloworld_vpc.id
  cidr_block = cidrsubnet(aws_vpc.helloworld_vpc.cidr_block, 8, 2)
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    name = "public-az2"
  }
}

resource "aws_subnet" "public_us-east-2c" {
  vpc_id = aws_vpc.helloworld_vpc.id
  cidr_block = cidrsubnet(aws_vpc.helloworld_vpc.cidr_block, 8, 3)
  availability_zone = "us-east-2c"
  map_public_ip_on_launch = true

  tags = {
    name = "public-az3"
  }
}
