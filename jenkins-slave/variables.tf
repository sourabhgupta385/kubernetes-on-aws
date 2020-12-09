variable "jenkins_slave_ami" {
    description = "AMI for Jenkins Slave"
    type        = string
    default     = "ami-00ddb0e5626798373"
}

variable "jenkins_slave_instance_type" {
    description = "Instance type for Jenkins Slave"
    type        = string
    default     = "t2.micro"
}