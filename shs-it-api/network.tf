
# VPC
resource "aws_vpc" "shs-it-vpc" {
  cidr_block = "10.3.0.0/16"

  tags = {
    Name = "shs-it-vpc"
  }
}

# Internet Gateway (IGW)
resource "aws_internet_gateway" "shs-it-igw" {
  vpc_id = aws_vpc.shs-it-vpc.id

  tags = {
    Name = "shs-it-igw"
  }
}

# Subnet
resource "aws_subnet" "shs-it-subnet-1" {
  vpc_id     = aws_vpc.shs-it-vpc.id
  cidr_block = "10.3.1.0/24"
  tags = {
    Name = "shs-it-subnet-1"
  }
}

# Route Table
resource "aws_route_table" "shs-it-route-table-1" {
  vpc_id = aws_vpc.shs-it-vpc.id

  # configuration block
  route {
    cidr_block = "0.0.0.0/0" #every ip that isn't the subnet's own ip
    gateway_id = aws_internet_gateway.shs-it-igw.id
  }
  tags = {
    Name = "shs-it-route-table-1"
  }
}

# RoutTable-Subnet Association: we need to associate the route table to the subnet
resource "aws_route_table_association" "shs-it-route-table-association-1" {
  subnet_id      = aws_subnet.shs-it-subnet-1.id
  route_table_id = aws_route_table.shs-it-route-table-1.id
}

# Network Acess Control List (NACL)
resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.shs-it-vpc.id

  # inbound traffic
  ingress {
    protocol   = "-1" #allow all protocols udp, tcp...
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "shs-it-network-acl-1"
  }

}
