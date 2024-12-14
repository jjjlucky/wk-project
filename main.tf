# Security Group for Web Server
resource "aws_security_group" "webserver_sg" {
    name        = "webserver_sg"
    description = "Security group for the UTC web server"
    vpc_id      = aws_vpc.v1.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "webserver_sg"
        Environment = "dev"
        CreatedBy   = "Joseph Lucky"
    }
}

# Key pair 
resource "tls_private_key" "tls" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

resource "aws_key_pair" "key" {
    key_name   = "ec2-key"
    public_key = tls_private_key.tls.public_key_openssh
}

resource "local_file" "key1" {
    filename = "ec2-key.pem"
    content  = tls_private_key.tls.private_key_pem
}

# Create EC2 instance 
resource "aws_instance" "webserver1" {
    associate_public_ip_address = true
    ami                   = "ami-0166fe664262f664c"  # Ensure this AMI is valid for your region
    instance_type         = "t2.micro"
    key_name              = aws_key_pair.key.key_name
    vpc_security_group_ids = [aws_security_group.webserver_sg.id]  # Reference by ID
    subnet_id              = aws_subnet.pub1.id
    user_data             = file("userdata.sh")

    tags = {
        Name = "Terraform-ec2"
    }
}


output "public-ip" {
    value = aws_instance.webserver1.public_ip
  
}