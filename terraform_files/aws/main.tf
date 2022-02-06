data "hcp_packer_iteration" "test" {
  bucket_name = "aws-nginx"
  channel     = "test"
}

data "hcp_packer_image" "nginx" {
  bucket_name    = "aws-nginx"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.test.ulid
  region         = "us-east-1"
}

resource "aws_security_group" "webserver" {
  name        = "${var.owner}-demo"
  vpc_id      = var.vpc_id

  ingress {
    description      = "nginx"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.owner
  }
}

resource "aws_instance" "webserver" {
  ami                    = data.hcp_packer_image.nginx.cloud_image_id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.webserver.id]

  tags = {
    Name = var.owner
  }
}
