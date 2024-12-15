variable "aws_access_key" {
  default = "AKIASFIXDDWFJUFT4TGX"
}

variable "aws_secret_key" {
  default = "+0okz2uKMdnJLlj36I20nS/B59Wz3Zcd8rjLhQP2"
}

source "amazon-ebs" "ubuntu" {
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  region                      = "ap-south-1"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  instance_type              = "t2.micro"
  ssh_username               = "ubuntu"
  ami_name                   = "Jenkins_Agent_ubuntu_packer_with_SSH_pub-test"
  security_group_ids         = ["sg-02f57b238deef56c3"]
  associate_public_ip_address = true
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo -u ubuntu ssh-keygen -f /home/ubuntu/.ssh/id_rsa -N ''",
      "sudo add-apt-repository ppa:openjdk-r/ppa -y",
      "sudo apt-get update -y",
      "sudo apt-get install -y openjdk-8-jdk",
      "java -version",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable\" -y",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce",
      "sudo mkdir -p /home/ubuntu/remoting /home/ubuntu/workspace",
      "sudo chmod -R 777 /home/ubuntu/remoting /home/ubuntu/workspace",
      "sudo usermod -aG docker $USER",
      "sudo systemctl enable docker"
    ]
  }
}
