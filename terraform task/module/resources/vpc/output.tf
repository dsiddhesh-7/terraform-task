output "my_vpc_cidr" {
    value = aws_vpc.my_vpc.cidr_block
  
}
output "my_pub_subnet" {
    value = aws_subnet.pub_subnet.cidr_block

}

output "my_pvt_subnet" {
    value = aws_subnet.pvt_subnet.cidr_block
  
}
output "my_igw" {
    value = aws_internet_gateway.my_igw.id
  
}