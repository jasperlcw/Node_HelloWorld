resource "aws_route_table" "helloworld-rt-public" {
  vpc_id = aws_vpc.helloworld_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.helloworld_igw.id
  }
  tags = {
    name = "public-rt"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public_us-east-2a.id
  route_table_id = aws_route_table.helloworld-rt-public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public_us-east-2b.id
  route_table_id = aws_route_table.helloworld-rt-public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id = aws_subnet.public_us-east-2c.id
  route_table_id = aws_route_table.helloworld-rt-public.id
}