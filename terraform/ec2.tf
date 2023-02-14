provider "aws" {
  region     = "ap-south-1"
}
resource "aws_instance" "Demo" {
  ami           = "ami-0597375488017747e"
  instance_type = "t2.micro"
  key_name = "aws"
  tags = {
    Name = "demo"
  }
  
user_data = <<EOF
#!/bin/bash
echo "Copying the SSH Key Of Jenkins to the server"
sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNYylxy8BXV2ujNVcZGR/mFi0qOTpFoCwJRCUCXgpUYQpM8caNPmY2NNmuUk2hp2yqaqb3DEg05lZ1+65lE8f51D/d25gSLsHmZrTfHG+SKrayTKA9RKb3/nypCpI246mrBXA2we8jN3svWPE5KJyhotuNVbAXdtasBFrKPkD89UCMDwqkvll8B6o2VLtGrIPBdIPwKMwONPh1xCQpYtrdOBfaqq0/t/Ruyuo6UWs7zJk4XzCNB8OgSYBakYEIok40bmyYhXW0Jwi41UJo90rBG/Mjmihju3+1a5VW03gxv+UG09VivVzTWPLTmu8GbmPbwtJcE7goxfmFITWaAjrjt37yjkjmOHC9U1xtRAIKW+ukTIvbtM6EEpDUaFDX+g/SlXbtzkR8gmPV4wfmbDrxmj+eNKc8FgACAaQFXd/Ud8PB0meJDDW+N6J4TVHKuRxZ//jPLAxaDwK/6+hZ8X6V0cQJRf+XNfkHixjhXb2LfHJoEsAS8zHY4BCUfx2n7tc= jenkins@ip-172-31-42-86" >> /home/ubuntu/.ssh/authorized_keys
EOF
}
output "vmpublic_ip" {
  value = "${aws_instance.Demo.public_ip}"
}
