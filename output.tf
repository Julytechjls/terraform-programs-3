locals {
  subnet_names = [for i in aws_subnet.subnet : "subnet-${i.availability_zone}"]
}
 
output "subnet_names" {
  value = local.subnet_names
}

output "subnet_ids" {
  value = aws_subnet.subnet[*].id
}