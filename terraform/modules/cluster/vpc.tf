data "aws_availability_zones" "available" {}

resource "aws_vpc" "tf_vpc" {
  cidr_block = var.cidr
  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "${var.env}-gw"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["az"]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-subnet"
  }

}

resource "aws_route_table" "public" {
  for_each = var.public_subnets
  vpc_id   = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  route_table_id = aws_route_table.public[each.key].id
  subnet_id      = aws_subnet.public[each.key].id

}


resource "aws_eip" "nat_eip" {
  for_each = var.private_subnets

  vpc = true
  tags = {
    Name = "${var.env}-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each = var.private_subnets

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = {
    Name = "${var.env}-private-subnet"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[each.key].id
  }
  tags = {
    Name = "${var.env}-private-rt"
  }
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  route_table_id = aws_route_table.private[each.key].id
  subnet_id      = aws_subnet.private[each.key].id
}
