# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main_vpc"
  }
}

# Create the public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

# Create the private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private_subnet"
  }
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main_nat_gateway"
  }
}

# Route Table for public subnet (routes 0.0.0.0/0 to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Route Table Association for public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route Table for private subnet (routes 0.0.0.0/0 to NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_rt"
  }
}

# Route Table Association for private subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Public EC2 instance in public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-0150ccaf51ab55a51"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name = "aws_practice"


  tags = {
    Name = "public_instance"
  }
}

# Private EC2 instance in private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-0150ccaf51ab55a51"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  key_name = "aws_practice"

  tags = {
    Name = "private_instance"
  }
}
