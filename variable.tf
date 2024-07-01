# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# Defining CIDR Block for 1st Subnet
variable "subnet1_cidr" {
  default = "10.0.0.0/28"
}
#defining the second cidar block for 2nd subnet
variable "subnet2_cidr" {
  default = "10.0.0.16/28"
}