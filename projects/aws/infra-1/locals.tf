locals {
    project = {
        name = terraform.workspace == "prod" ? "prod-lab" : "tests-lab"
    }
    
    provider = {
        profile = "terraform"
        region  = terraform.workspace == "prod" ? "us-east-2" : "us-east-1"
    }
    network = {
        vpc_cidr = terraform.workspace == "prod" ? "10.1.0.0/16" : "10.0.0.0/16"
        public_az1_cidr = terraform.workspace == "prod" ? "10.1.11.0/24" : "10.0.11.0/24"
        public_az2_cidr = terraform.workspace == "prod" ? "10.1.12.0/24" : "10.0.12.0/24"
        public_az3_cidr = terraform.workspace == "prod" ? "10.1.13.0/24" : "10.0.13.0/24"
        private_az1_cidr = terraform.workspace == "prod" ? "10.1.21.0/24" : "10.0.21.0/24"
        private_az2_cidr = terraform.workspace == "prod" ? "10.1.22.0/24" : "10.0.22.0/24"
        private_az3_cidr = terraform.workspace == "prod" ? "10.1.23.0/24" : "10.0.23.0/24"
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
            ami          =  terraform.workspace == "prod" ? "ami-0ec3d9efceafb89e0" : "ami-058bd2d568351da34" #Debian 12
        }

        backend = {
            machine_type = "t3.micro"
            ami          =  terraform.workspace == "prod" ? "ami-0ec3d9efceafb89e0" : "ami-058bd2d568351da34" #Debian 12
        }

        gateway = {
            machine_type = "t3.micro"
            ami          = terraform.workspace == "prod" ? "ami-056d6c2cc103e038c" : "ami-024cf76afbc833688" #EC2 NAT
        }

        jumpbox = {
            machine_type = "t3.micro"
            ami          =  terraform.workspace == "prod" ? "ami-0ec3d9efceafb89e0" : "ami-058bd2d568351da34" #Debian 12
        }
    }
}