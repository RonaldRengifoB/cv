locals {
    project = {
        name = "final-lab"
    }
    
    provider = {
        profile = "terraform"
        region  = "us-east-2"
    }
    network = {
        vpc_cidr = "10.0.0.0/16"
        public_az1_cidr = "10.0.11.0/24"
        public_az2_cidr = "10.0.12.0/24"
        public_az3_cidr = "10.0.13.0/24"
        private_az1_cidr = "10.0.21.0/24"
        private_az2_cidr = "10.0.22.0/24"
        private_az3_cidr = "10.0.23.0/24"
    }
    db = {
        name = "nodedb"
        username = "dbnodeuser"
        #i know i know
        password = "dbn0d3supers3cr3t"
    }
    ec2 = {
        frontend = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian 12
            user_data    = ""
        }

        backend = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian 12
            user_data    =  ""
        }

        gateway = {
            machine_type = "t3.micro"
            ami          = "ami-056d6c2cc103e038c" #EC2 NAT
            user_data    = ""
        }

        jumpbox = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian
            user_data    = <<-EOF
                            #!/bin/bash
                            sudo apt update
                            sudo apt install -y pipx pip python3-full ansible default-mysql-client
                            sudo chmod 0400 /home/admin/.ssh/terraform
                            EOF
        }
    }
}