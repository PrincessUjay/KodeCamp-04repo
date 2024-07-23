# modules/instances/main.tf
resource "aws_instance" "main" {
  ami                    = "ami-0c21ae4a6fdadacc0"  # Ubuntu 20.04 LTS in eu-west-1
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  security_groups        = [var.security_group]

  user_data = file(var.script_path)

  tags = {
    Name = "EC2Instance"
  }
}

output "instance_id" {
  value = aws_instance.main.id
}