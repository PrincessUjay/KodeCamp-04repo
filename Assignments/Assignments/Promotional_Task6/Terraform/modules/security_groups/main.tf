# modules/security_groups/main.tf
resource "aws_security_group" "main" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.type == "public" ? 80 : 5432
    to_port     = var.type == "public" ? 80 : 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.type == "public" ? [var.ssh_cidr] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.type == "public" ? "PublicSG" : "PrivateSG"
  }
}