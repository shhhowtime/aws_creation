resource "aws_subnet" "public" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "10.0.16.0/20"
  availability_zone = data.aws_availability_zones.zone.names[0]
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.PublicRT.id
}