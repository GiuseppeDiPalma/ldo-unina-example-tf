resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.cidr_block_range
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.stackid_tf}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.stackid_tf}-igw"
  }
}

resource "aws_eip" "ngw_eip" {
  domain           = "vpc"
  public_ipv4_pool = "amazon"

  tags = {
    Name = "${var.stackid_tf}-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name = "${var.stackid_tf}-ngw"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_public_a_cidr_block_range
  map_public_ip_on_launch = "true"
  availability_zone       = var.vpc.availability_zones["az-a"]
  tags = {
    Name = "${var.stackid_tf}-public_a"
    Type = "Public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_public_b_cidr_block_range
  map_public_ip_on_launch = "true"
  availability_zone       = var.vpc.availability_zones["az-b"]
  tags = {
    Name = "${var.stackid_tf}-public_b"
    Type = "Public"
  }
}

# resource "aws_subnet" "public_c" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.vpc.subnet_public_c_cidr_block_range
#   map_public_ip_on_launch = "true"
#   availability_zone       = var.availability_zones["az-c"]
#   tags = {
#     Name = "${var.stackid_tf}-public_c"
#     Type = "Public"
#   }
# }

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_private_a_cidr_block_range
  map_public_ip_on_launch = "false"
  availability_zone       = var.vpc.availability_zones["az-a"]
  tags = {
    Name = "${var.stackid_tf}-private_a"
    Type = "Private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_private_b_cidr_block_range
  map_public_ip_on_launch = "false"
  availability_zone       = var.vpc.availability_zones["az-b"]
  tags = {
    Name = "${var.stackid_tf}-private_b"
    Type = "Private"
  }
}

# resource "aws_subnet" "private_c" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.vpc.subnet_private_c_cidr_block_range
#   map_public_ip_on_launch = "false"
#   availability_zone       = var.availability_zones["az-c"]
#   tags = {
#     Name = "${var.stackid_tf}-private_c"
#     Type = "Private"
#   }
# }

resource "aws_subnet" "db_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_db_a_cidr_block_range
  map_public_ip_on_launch = "false"
  availability_zone       = var.vpc.availability_zones["az-a"]
  tags = {
    Name = "${var.stackid_tf}-db_a"
    Type = "Private"
  }
}

resource "aws_subnet" "db_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.subnet_db_b_cidr_block_range
  map_public_ip_on_launch = "false"
  availability_zone       = var.vpc.availability_zones["az-b"]
  tags = {
    Name = "${var.stackid_tf}-db_b"
    Type = "Private"
  }
}

# resource "aws_subnet" "db_c" {
#   vpc_id                  = aws_vpc.vpc.id
#   cidr_block              = var.vpc.subnet_db_c_cidr_block_range
#   map_public_ip_on_launch = "false"
#   availability_zone       = var.availability_zones["az-c"]
#   tags = {
#     Name = "${var.stackid_tf}-db_c"
#     Type = "Private"
#   }
# }

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.stackid_tf}-public_rtb"
    Type = "Public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rtb_public.id
}

# resource "aws_route_table_association" "public_c" {
#   subnet_id      = aws_subnet.public_c.id
#   route_table_id = aws_route_table.rtb_public.id
# }

resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${var.stackid_tf}-private_rtb"
    Type = "Private"
  }
}

resource "aws_route_table_association" "rta_subnet_private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.rtb_private.id
}

resource "aws_route_table_association" "rta_subnet_private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.rtb_private.id
}

# resource "aws_route_table_association" "rta_subnet_private_c" {
#   subnet_id      = aws_subnet.private_c.id
#   route_table_id = aws_route_table.rtb_private.id
# }

resource "aws_route_table" "rtb_db" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.stackid_tf}-db_rtb"
    Type = "Private"
  }
}

resource "aws_route_table_association" "rta_subnet_db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.rtb_db.id
}

resource "aws_route_table_association" "rta_subnet_db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.rtb_db.id
}

# resource "aws_route_table_association" "rta_subnet_db_c" {
#   subnet_id      = aws_subnet.db_c.id
#   route_table_id = aws_route_table.rtb_db.id
# }
