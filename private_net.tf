resource "aws_subnet" "private" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "10.0.32.0/20"
  availability_zone = data.aws_availability_zones.zone.names[1]
}

resource "aws_eip" "NAT_IP" {
  vpc = true
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.NAT_IP.id
  subnet_id = aws_subnet.public.id
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW.id
  }
}

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.PrivateRT.id
}