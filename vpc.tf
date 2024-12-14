# Create VPC
resource "aws_vpc" "v1" {
  cidr_block           = "172.120.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "utc-app"
    env  = "dev"
    team = "cloud team"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gtw" {
  vpc_id = aws_vpc.v1.id

  tags = {
    Name       = "dev-cloud-gtw"
    env        = "dev"
    created_by = "Joseph Lucky"
  }
}

# NAT Gateway
resource "aws_eip" "eip1" {}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name       = "utc-nat-gtw"
    created_by = "Joseph Lucky"
  }
}

# Public Subnets
resource "aws_subnet" "pub1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.v1.id
  cidr_block        = "172.120.1.0/24"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "pub2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.v1.id
  cidr_block        = "172.120.2.0/24"

  tags = {
    Name = "Public Subnet 2"
  }
}

# Private Subnets
resource "aws_subnet" "priv1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.v1.id
  cidr_block        = "172.120.3.0/24"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "priv2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.v1.id
  cidr_block        = "172.120.4.0/24"

  tags = {
    Name = "Private Subnet 2"
  }
}

# Create Route Table
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.v1.id

  tags = {
    Name = "public-route-table"
  }
}

# Create Route for the Route Table
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.rtpublic.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gtw.id
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "purt1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "purt2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.rtpublic.id
}