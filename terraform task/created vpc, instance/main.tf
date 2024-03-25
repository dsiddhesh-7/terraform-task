//create vpc
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "my_vpc"
  }
}

//create pub subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/18"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

//create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "igw"
  }
}

//create route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

//create association table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

//create pvt subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.64.0/19"

  tags = {     
    Name = "private"
  }
}

//crete natgateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "eipalloc-0a752e8c005dcbfa8" //, aws_instance.this_aws_public_instance[0].network_interface_ids[0]] # [count of instance]
 subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route_table" "pvt_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "pvt_route_ta"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.pvt_route_table.id
}


//attached network nacl
resource "aws_network_acl" "this_nacl" {
  vpc_id     = aws_vpc.my_vpc.id
  subnet_ids = [aws_subnet.public_subnet.id]

  egress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    protocol   = -1
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0

  }
}

//create instance
resource "aws_instance" "instance" {
  ami                         = "ami-052c9ea013e6e3567"
  instance_type               = "t2.micro"
  key_name                    = "oregon"
  vpc_security_group_ids      = [aws_security_group.sg.id]
  availability_zone           = "us-west-2a"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  root_block_device {
    volume_size = 8
  }
  //user_data_base64 = var.this_aws_instance_user_data_base64

  tags = {
    Name = "instance"
  }

}