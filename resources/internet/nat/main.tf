resource "aws_nat_gateway" "this" {
  subnet_id = var.subnet_id
  
  tags = {
    Name = "internet-NAT-GW" 
  }
}