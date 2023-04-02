# Define a variable to create resources in the Jenkins VPC.

variable "jenkins_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "jenkins_vpc_public_subnet" {
  type = map(any)
  default = {
    public_subnet_az_a = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "Jenkins Public Subnet AZ a"
    }
    public_subnet_az_c = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "Jenkins Public Subnet AZ c"
    }
  }
}

variable "jenkins_vpc_private_subnet" {
  type = map(any)
  default = {
    private_subnet_az_a = {
      cidr_block        = "10.0.10.0/24"
      availability_zone = "ap-northeast-2a"
      name              = "Jenkins Private Subnet AZ a"
    }
    private_subnet_az_c = {
      cidr_block        = "10.0.11.0/24"
      availability_zone = "ap-northeast-2c"
      name              = "Jenkins Private Subnet AZ c"
    }
  }
}
