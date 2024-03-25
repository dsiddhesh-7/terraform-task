//launch instance
resource "aws_instance" "my_instance" {
    ami = "0eb5115914ccc4bc2"
    instance_type = var.my_instance_instance_type
    key_name = var.my_instance_key_name
    availability_zone = var.my_instance_avaibality_zone
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    root_block_device {
      volume_size = var.my_instance_volume_size
    }
    user_data_base64 = "true"
    tags = {
      name = "my_instance"
    }
  
}

//security group
resource "aws_security_group" "my_sg" {
    name = "my_sg"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


  
}