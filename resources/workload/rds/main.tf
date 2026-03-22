resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  manage_master_user_password = true

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.this.id]

  skip_final_snapshot = true
  apply_immediately = true
  deletion_protection = false

  tags = {
    Name = "aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "name" {
    count              = var.instance_count

    identifier         = "${var.cluster_identifier}-${count.index+1}"
    cluster_identifier = aws_rds_cluster.this.id
    instance_class     = var.instance_class
    engine             = aws_rds_cluster.this.engine
    engine_version     = aws_rds_cluster.this.engine_version

    publicly_accessible = false

    tags = {
        Name = "aurora-instance-${count.index}"
    }
}

resource "aws_db_subnet_group" "this" {
  name = "rds-db-cluster-subnet-grp"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "rds-db-cluster-subnet-grp"
  }
}

resource "aws_security_group" "this" {
  name = "rds-cluster-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "rds-cluster-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ECS_inbound" {
    security_group_id = aws_security_group.this.id

    referenced_security_group_id = var.referenced_security_group_id
    from_port = 5432
    to_port = 5432
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
    security_group_id = aws_security_group.this.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = -1
}