resource "aws_db_instance" "rds_instance" {
  identifier           = "${var.tags["Name"]}-rds" # Use identifier for the instance's name
  allocated_storage  = 20
  instance_class     = "db.t3.micro"
  engine             = "mysql"
  engine_version     = "8.0"
  db_name            = "wordpressdb" # Use db_name for the database name
  username           = var.rds_username
  password           = var.rds_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  # Add these lifecycle settings to prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #  IMPORTANT: Restrict this in production!
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group" # Use a descriptive name
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}