resource "aws_vpc" "kmer_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "douala" {
  vpc_id                  = aws_vpc.kmer_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "yaounde" {
  vpc_id            = aws_vpc.kmer_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"
  tags = {
    Name = var.private_subnet_name
  }
}

# Security group for public EC2 instance (Douala)
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Allow inbound SSH from the internet"
  vpc_id      = aws_vpc.kmer_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for private EC2 instance (Yaounde)
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow inbound SSH from the public subnet"
  vpc_id      = aws_vpc.kmer_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id] # Allow access from public EC2 instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance in the public subnet (Douala)
resource "aws_instance" "douala" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.douala.id
  key_name        = var.keypair_name
  security_groups = [aws_security_group.public_sg.id] # Use the security group ID here
  tags = {
    Name = "Douala"
  }

  depends_on = [
    aws_security_group.public_sg
  ]
}

# EC2 instance in the private subnet (Yaounde)
resource "aws_instance" "yaounde" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.yaounde.id
  key_name        = var.keypair_name
  security_groups = [aws_security_group.private_sg.id] # Use the security group ID here
  tags = {
    Name = "Yaounde"
  }

  depends_on = [
    aws_security_group.private_sg
  ]
}
