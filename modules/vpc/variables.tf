variable "region" {
  type = string
}
variable "vpc_cidr" {
      type = string
}
variable "availability_zone" {
    type = list(string)
}
variable "public_subnet" {
    type = list(string)
}

variable "private_subnet" {
    type = list(string)
}