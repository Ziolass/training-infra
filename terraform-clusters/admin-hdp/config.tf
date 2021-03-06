provider "aws" {
    access_key = "XXXX"
    secret_key = "XXXX"
    region = "us-west-2"
}

resource "aws_instance" "cdh-master" {
    ami = "ami-4dbf9e7d"
    instance_type = "m3.xlarge"
    count = 6
    key_name = "oregon"

    root_block_device {
        volume_size = 40
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install -y ntp",
            "sudo systemctl enable ntpd",
            "sudo systemctl start ntpd",
            "sudo /sbin/chkconfig ntpd on",
            "sudo /etc/init.d/ntpd start",
            "sudo yum -y upgrade openssl",
            "sudo yum -y install wget"
        ]
          connection {
            user = "ec2-user"
            key_file = "oregon.pem"
          }
        }
}

resource "aws_instance" "cdh-slave" {
    ami = "ami-4dbf9e7d"
    instance_type = "m3.medium"
    count = 24
    key_name = "oregon"

    root_block_device {
        volume_size = 40
    }

   provisioner "remote-exec" {
        inline = [
            "sudo yum install -y ntp",
            "sudo systemctl enable ntpd",
            "sudo systemctl start ntpd",
            "sudo /sbin/chkconfig ntpd on",
	    "sudo /etc/init.d/ntpd start",
            "sudo yum -y upgrade openssl",
            "sudo yum -y install wget"
       ]
	  connection {
            user = "ec2-user"
            key_file = "oregon.pem"
          }
        }
}
