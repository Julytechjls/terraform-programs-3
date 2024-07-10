provider "aws" {
  region = "us-east-1"  # Cambia esto a tu región preferida
}

resource "aws_instance" "web" {
  ami           = "ami-01b799c439fd5516a"  # AMI de Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "vockey"  # Cambia esto al nombre de tu par de claves SSH
 
  tags = {
    Name = "WebServer"
  }
 
  # Define el Security Group para permitir tráfico HTTP y SSH
  vpc_security_group_ids = [aws_security_group.web_sg1.id]
 
   provisioner "file" {
    source      = "install_apache.sh"  # Update this to the correct path
    destination = "/tmp/install_apache.sh"
  }
 
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "sudo /tmp/install_apache.sh",
      "sudo wget https://www.free-css.com/assets/files/free-css-templates/download/page296/little-fashion.zip -O /tmp/little-fashion.zip",
      "sudo unzip /tmp/little-fashion.zip -d /var/www/html/",
      "sudo mv /var/www/html/2127_little_fashion/* /var/www/html/"
    ]
  }
 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("ssh.pem")  # Ruta a tu clave privada
    host        = self.public_ip
  }
}

resource "aws_security_group" "web_sg1" {
  name        = "web_sg1"
  description = "Allow HTTP and SSH traffic"
 
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
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

