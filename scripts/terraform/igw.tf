resource "aws_internet_gateway" "helloworld_igw" {
  vpc_id = aws_vpc.helloworld_vpc.id
}