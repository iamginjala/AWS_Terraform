
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu official)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_security_group" "psg" {
  name        = "tf-prov-demo-ssh"
  description = "Allow SSH inbound"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}
resource "aws_instance" "demo" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.psg.id]

  tags = {
    Name = "terraform-provisioner-demo"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
  provisioner "local-exec" {
    command = "echo 'Local-exec: created instance ${self.id} with IP ${self.public_ip}'"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "echo 'Hello from remote-exec' | sudo tee /tmp/remote_exec.txt",
    ]
  }
  
  provisioner "file" {
    source = "${path.module}/welcome.sh"
    destination = "/tmp/welcome.sh"
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod +x /tmp/welcome.sh",
                "sudo /tmp/welcome.sh" ]
    
  }
}
