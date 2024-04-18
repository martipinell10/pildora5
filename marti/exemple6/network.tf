# Creació VPC
resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

# Creació internet gateway.
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "vpc-igw"
  }
}

# Creació subxarxa pública per web tier.
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.az[count.index]

  tags = {
    Name = "public-subnet-AZ-${count.index + 1}"
  }
}

# Creació subxarxa privada per web tier.
resource "aws_subnet" "private_app_subnets" {
  count             = length(var.private_app_subnets_cidr)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_app_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "private-app-subnet-AZ-${count.index + 1}"
  }
}

# Creació subxarxa privada per la base de dades.
resource "aws_subnet" "private_db_subnets" {
  count             = length(var.private_db_subnets_cidr)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_db_subnets_cidr[count.index]
  availability_zone = var.az[count.index]

  tags = {
    Name = "private-db-subnet-AZ-${count.index + 1}"
  }
}

# Creació de la taula de rutes públiques i la configuració d'accés a internet.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Associar subxarxa pública amb la taula de rutes pública.
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Creació IP elàstica per al NAT gateway.
resource "aws_eip" "eip_natgw" {
  #   domain = "vpc"
}

# Creació del NAT gateway i allotjament de la IP elàstica.
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_natgw.id
  subnet_id     = element(aws_subnet.public_subnets, 0).id

  tags = {
    Name = "NAT-gw"
  }

  depends_on = [aws_internet_gateway.vpc_igw]
}

# Creació taula de rutes privada per private app tier.
resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-app-rt"
  }
}

# Associar subsarxa de la app rivada amb la taula de rutes privada.
resource "aws_route_table_association" "private_app_rt_assoc" {
  count          = length(aws_subnet.private_app_subnets)
  subnet_id      = aws_subnet.private_app_subnets[count.index].id
  route_table_id = aws_route_table.private_app_rt.id
}

# Creació de la taula de rutes privada amb la tier privada de la BBDD.
resource "aws_route_table" "private_db_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-db-rt"
  }
}

# Associació de la subxarxa privada de la BBDD amb la taula de rutes privada.
resource "aws_route_table_association" "private_db_rt_assoc" {
  count          = length(aws_subnet.private_db_subnets)
  subnet_id      = aws_subnet.private_db_subnets[count.index].id
  route_table_id = aws_route_table.private_db_rt.id
}
