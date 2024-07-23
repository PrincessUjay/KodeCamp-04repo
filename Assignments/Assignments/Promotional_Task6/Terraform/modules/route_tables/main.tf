# modules/route_tables/main.tf
resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.is_public ? var.igw_id : var.nat_gateway_id
  }

  tags = {
    Name = var.is_public ? "PublicRouteTable" : "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "main" {
  count = length(var.subnet_ids)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.main.id
}

output "route_table_id" {
  value = aws_route_table.main.id
}