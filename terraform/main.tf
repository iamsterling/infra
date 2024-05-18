provider "aws" {
  region = "us-east-1"  # Adjust this to your preferred region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MyVPC"
  }
}