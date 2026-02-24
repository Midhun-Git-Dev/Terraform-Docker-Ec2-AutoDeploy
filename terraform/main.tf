resource "aws_instance" "my_ec2" {
    ami = data.aws_ami.amazon_linux.id
    instance_type = var.instance_type
    key_name = var.key_name


    vpc_security_group_ids = [aws_security_group.web_sg.id]


    user_data = file("user-data.sh")

  
    tags = {
      Name = "Terraform-Docker-EC2"

   }
}  
