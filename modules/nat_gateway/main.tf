
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id

    tags = {
      Name = "gw_NAT"
    }
}

resource "aws_route" "private_nat_associations" {
    count = length(var.private_rt_id)
    route_table_id = var.private_rt_id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


# resource "aws_route_table" "private_NAT_rt" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }
# }

# resource "aws_route_table_association" "a" {
#   subnet_id = var.private_subnet_id
#   route_table_id = aws_route_table.private_NAT_rt.id
# }