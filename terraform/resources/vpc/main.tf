# Defined jenkins vpc

resource "aws_vpc" "jenkins" {
  cidr_block           = var.jenkins_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Jenkins VPC"
  }
}


# Defined jenkins vpc subnet

resource "aws_subnet" "jenkins_vpc_public" {
  for_each                = var.jenkins_vpc_public_subnet
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "jenkins_vpc_private" {
  for_each          = var.jenkins_vpc_private_subnet
  vpc_id            = aws_vpc.jenkins.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.value.name
  }
}


# Defined jenkins vpc internet gateway and nat gateway

resource "aws_internet_gateway" "jenkins_vpc" {
  vpc_id = aws_vpc.jenkins.id

  tags = {
    Name = "Jenkins VPC Internet Gateway"
  }
}

resource "aws_eip" "jenkins_vpc" {
  for_each = var.jenkins_vpc_public_subnet
  vpc      = true

  tags = {
    Name = "Jenkins VPC NAT EIP (${each.key})"
  }
}

resource "aws_nat_gateway" "jenkins_vpc" {
  for_each      = aws_subnet.jenkins_vpc_public
  allocation_id = aws_eip.jenkins_vpc[each.key].id
  subnet_id     = each.value.id

  tags = {
    Name = "Jenkins VPC NAT Gateway (${each.key})"
  }
}


# Defined jenkins vpc route table

resource "aws_route_table" "jenkins_vpc_public" {
  vpc_id = aws_vpc.jenkins.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_vpc.id
  }

  tags = {
    Name = "Jenkins VPC Public Subnet Route Table"
  }
}

resource "aws_route_table" "jenkins_vpc_private" {
  for_each = aws_nat_gateway.jenkins_vpc
  vpc_id   = aws_vpc.jenkins.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "Jenkins VPC Private Subnet Route Table (${each.key})"
  }
}


# Defined jenkins vpc route table association

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = aws_subnet.jenkins_vpc_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.jenkins_vpc_public.id
}

resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.jenkins_vpc_private["private_subnet_az_a"].id
  route_table_id = aws_route_table.jenkins_vpc_private["public_subnet_az_a"].id
}

resource "aws_route_table_association" "private_route_table_association_c" {
  subnet_id      = aws_subnet.jenkins_vpc_private["private_subnet_az_c"].id
  route_table_id = aws_route_table.jenkins_vpc_private["public_subnet_az_c"].id
}
