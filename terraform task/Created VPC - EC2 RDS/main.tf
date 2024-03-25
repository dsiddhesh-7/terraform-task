resource "aws_instance" "instance" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  key_name               = "n.virginia"
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  availability_zone      = "us-east-1a"
   root_block_device {
    volume_size          = 8
  }
 
  tags = {
    user_data_base64 = "true"
    Name = "instance" 
  }
}



resource "aws_security_group" "aws_sg" {

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



}
data "aws_ami" "this_aws_ami" {
  
   name_regex = "ami_use"
   owners = ["self"]

}
 
resource "aws_db_instance" "aws-db" {
  instance_class = "db.t2.micro"
  vpc_security_group_ids = ["sg-07a08c081391c0cb5"]
  engine                 = "mysql"
  username               = "admin"
  password               = "12345"
  allocated_storage      = 10
  db_name                = "student_app"
  storage_type           = "gp2"
}

//create aws vpc 
resource "aws_vpc" "demo_vpc" {
    cidr_block = "10.10.0.0/16"
}

//create aws subnet
resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.10.0.0/24"

    tags = {
      name = "pub_subnet"
    }
}
resource "aws_subnet" "pvt_subnet" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.10.1.0/24"

    tags = {
      name = "pvt_subnet"
    }
}

//create aws internet gateway 
resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id

    tags = {
      name = "demo_igw"
    }
}

//create aws route table 
resource "aws_route_table" "demo_route" {
    vpc_id = aws_vpc.demo_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }

    tags = {
      name = "demo_route"
    }
}


 //associate subnet with route table
resource "aws_route_table_association" "demo_route_association" {
    subnet_id = aws_subnet.pub_subnet.id
    route_table_id = aws_route_table.demo_route.id
  
}