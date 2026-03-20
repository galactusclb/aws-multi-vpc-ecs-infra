resource "aws_ec2_transit_gateway" "this" {
  description = "Transit gateway to connect multiple VPCs"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id = var.vpc_id_workload
  subnet_ids = var.subnets_workload

  tags = {
    Name = "workload-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id = var.vpc_id_internet
  subnet_ids = var.subnets_internet

  tags = {
    Name = "internet-vpc-attachment"
  }
}