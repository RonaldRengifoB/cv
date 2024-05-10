locals {
    project = {
        name = "prod-lab"
    }
    
    provider = {
        profile = "terraform"
        region  = "us-east-2"
    }
    network = {
        vpc_cidr = "10.1.0.0/16"
        public_az1_cidr = "10.1.11.0/24"
        public_az2_cidr = "10.1.12.0/24"
        public_az3_cidr = "10.1.13.0/24"
        private_az1_cidr = "10.1.21.0/24"
        private_az2_cidr = "10.1.22.0/24"
        private_az3_cidr = "10.1.23.0/24"
    }
    db = {
        name = "nodedb"
        username = "dbnodeuser"
        #i know i know
        password = "dbn0d3supers3cr3t"
        port = "3306"
    }

    frontend = {
        port = "3030"
    }

    backend = {
        port = "3000"
    }
    
    ec2 = {
        frontend = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian 12
        }

        backend = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian 12
        }

        gateway = {
            machine_type = "t3.micro"
            ami          = "ami-056d6c2cc103e038c" #EC2 NAT
        }

        jumpbox = {
            machine_type = "t3.micro"
            ami          = "ami-0ec3d9efceafb89e0" #Debian
        }
    }
}