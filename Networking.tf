# Define our VPC
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
 
 tags= {
    Name = "themuskvpc"
    Environment = "Dev"
  }
}

# Define the first public subnet
resource "aws_subnet" "public-subnetfirst" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet1_cidr}"
  availability_zone = "us-east-1a"

  tags= {
    Name = "themuskvpcpublicsubnet1"
    Environment = "Dev"
  }
}

# Define the second public subnet
resource "aws_subnet" "public-subnetsecond" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet2_cidr}"
  availability_zone = "us-east-1b"

  tags= {
    Name = "themuskvpcpublicsubnet1"
    Environment = "Dev"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags= {
    Name = "themuskIGW"
    Environment = "Dev"
  }
}

# Define the route table for first public subnet
resource "aws_route_table" "rtfirst" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags= {
    Name = "themuskpublicsubnetfirstroutetable"
    Environment = "Dev"
  }
}

# Define the route table for second public subnet
resource "aws_route_table" "rtsecond" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags= {
    Name = "themuskpublicsubnetsecondroutetable"
    Environment = "Dev"
  }
}

# Assign the route table to the first public Subnet
resource "aws_route_table_association" "rtapublicsubnetfirst" {
  subnet_id = "${aws_subnet.public-subnetfirst.id}"
  route_table_id = "${aws_route_table.rtfirst.id}"
}

# Assign the route table to the second public Subnet
resource "aws_route_table_association" "rtapublicsubnetsecond" {
  subnet_id = "${aws_subnet.public-subnetsecond.id}"
  route_table_id = "${aws_route_table.rtsecond.id}"
}

# Define the security group for public subnets
resource "aws_security_group" "sgpublic" {
  name = "themuskpublicsg"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

   ingress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = [
         "${var.public_subnet1_cidr}",
         "${var.public_subnet2_cidr}"]
    }

    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.default.id}"

  tags= {
    Name = "themuskpublicsg"
    Environment = "Dev"
  }
}

