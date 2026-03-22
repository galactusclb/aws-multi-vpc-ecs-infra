resource "aws_ec2_transit_gateway" "this" {
  description                     = "Transit gateway to connect multiple VPCs"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "workload" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id_workload
  subnet_ids         = var.subnets_workload

  tags = {
    Name = "workload-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.vpc_id_internet
  subnet_ids         = var.subnets_internet

  tags = {
    Name = "internet-vpc-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table" "workload" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "workload-egress-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "internet" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "internet-ingress-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "workload" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

resource "aws_ec2_transit_gateway_route_table_association" "internet" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internet.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.internet.id
}

resource "aws_ec2_transit_gateway_route" "workload_default_to_internet" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internet.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "workload_to_internet" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.workload.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.internet.id
}
