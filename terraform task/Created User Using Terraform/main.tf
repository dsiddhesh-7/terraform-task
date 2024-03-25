
//add user in aws 
resource "aws_iam_user" "my_iam" {
  name = "terraform_siddhesh"
  path = "/"

  //add tag to the user
  tags = {
    name = "this user is created with the help of terraform"
  }

}

//Add the access key to the User
resource "aws_iam_access_key" "my_iam_access_key" {
  user = aws_iam_user.my_iam.name

}


//Create the Group
resource "aws_iam_group" "my_group" {
  name = "terraform_my_group"

}


//Add User & group in Group-Membership 
resource "aws_iam_group_membership" "member" {
  name = "terraform_group_memebership"

  users = [
    aws_iam_user.my_iam.name
  ]

  group = aws_iam_group.my_group.name
}
