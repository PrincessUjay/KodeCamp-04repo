# modules/nat_gateway/main.tf
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}