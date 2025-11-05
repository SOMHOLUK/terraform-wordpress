

resource "aws_vpc" "wordpress-vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env_prefix}-wordpress-vpc"
  }

}



resource "aws_internet_gateway" "wordpress-igw" {
  vpc_id = aws_vpc.wordpress-vpc.id

  tags = {
    Name = "${var.env_prefix}-wordpress-igw"
  }
}



resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.public_subnet_a_cidr_block
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet-a"
  }
}


resource "aws_subnet" "public-subnet-b" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.public_subnet_b_cidr_block
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet-b"
  }
}




resource "aws_subnet" "wordpress_a_privatesubnet" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = var.wordpress_a_privatesubnet_cidr_block
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.env_prefix}-wordpress-a-private-subnet"
  }
}


resource "aws_subnet" "wordpress_b_privatesubnet" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = var.wordpress_b_privatesubnet_cidr_block
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.env_prefix}-wordpress-b-private-subnet"
  }
}


resource "aws_subnet" "rds-a-privatesubnet" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = var.rds_a_privatesubnet_cidr_block
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.env_prefix}-rds-a-private-subnet"
  }
}


resource "aws_subnet" "rds-b-privatesubnet" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = var.rds_b_privatesubnet_cidr_block
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.env_prefix}-rds-b-private-subnet"
  }
}



resource "aws_route_table" "wp-public-rt" {
  vpc_id = aws_vpc.wordpress-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-wordpress-public-route-table"
  }
}


resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.wp-public-rt.id

}


resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.wp-public-rt.id
}




resource "aws_eip" "eip-1" {
  depends_on = [aws_internet_gateway.wordpress-igw]

  tags = {
    Name = "${var.env_prefix}-eip1"
  }
}



resource "aws_nat_gateway" "ngw-a" {
  allocation_id = aws_eip.eip-1.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "${var.env_prefix}-ngw-a"
  }

  depends_on = [aws_internet_gateway.wordpress-igw]
}



resource "aws_eip" "eip-2" {
  depends_on = [aws_internet_gateway.wordpress-igw]

  tags = {
    Name = "${var.env_prefix}-eip2"
  }
}


resource "aws_nat_gateway" "ngw-b" {
  allocation_id = aws_eip.eip-2.id
  subnet_id     = aws_subnet.public-subnet-b.id

  tags = {
    Name = "${var.env_prefix}-ngw-b"
  }
  depends_on = [aws_internet_gateway.wordpress-igw]
}




resource "aws_route_table" "wp-private-rt-a" {
  vpc_id = aws_vpc.wordpress-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-a.id
  }

  tags = {
    Name = "${var.env_prefix}-wordpress-private-route-table-a"
  }
}


resource "aws_route_table_association" "wordpress_a_privatesub" {
  subnet_id      = aws_subnet.wordpress_a_privatesubnet.id
  route_table_id = aws_route_table.wp-private-rt-a.id
}


resource "aws_route_table_association" "rds-a-privatesub" {
  subnet_id      = aws_subnet.rds-a-privatesubnet.id
  route_table_id = aws_route_table.wp-private-rt-a.id
}




resource "aws_route_table" "wp-private-rt-b" {
  vpc_id = aws_vpc.wordpress-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-b.id
  }

  tags = {
    Name = "${var.env_prefix}-wordpress-private-route-table-b"
  }
}



resource "aws_route_table_association" "wordpress_b_privatesub" {
  subnet_id      = aws_subnet.wordpress_b_privatesubnet.id
  route_table_id = aws_route_table.wp-private-rt-b.id
}


resource "aws_route_table_association" "rds-b-privatesub" {
  subnet_id      = aws_subnet.rds-b-privatesubnet.id
  route_table_id = aws_route_table.wp-private-rt-b.id
}
