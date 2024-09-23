output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "subnet_pub_ids" {
  value = { for k, v in aws_subnet.pub : k => v.id }
  #   value = values(aws_subnet.pub)[*].id
}

output "subnet_pri_ids" {
  value = { for k, v in aws_subnet.pri : k => v.id }
  #   value = values(aws_subnet.pri)[*].id
}

output "subnet_edp_ids" {
  value = { for k, v in aws_subnet.edp : k => v.id }
  #   value = values(aws_subnet.edp)[*].id
}

output "rtb_pub_id" {
  value = aws_route_table.pub.id
}

output "rtb_pri_id" {
  value = aws_route_table.pri.id
}

output "rtb_edp_id" {
  value = aws_route_table.edp.id
}
