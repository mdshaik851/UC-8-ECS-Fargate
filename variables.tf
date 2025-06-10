variable "region" {
    description = "Region"
    type = string
    default = "ca-central-1"

}

variable "count_numbers" {
  type = number
  default = 2
}


variable "vpc_cidr" {
    description = "VPC cidr range"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    description = "public subnets descriptions"
    type = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet" {
    description = "private subnets descriptions"
    type = list(string)
    default     = ["10.0.3.0/24", "10.0.4.0/24"]
}


variable "availability_zone" {
    description = "Availability Zones"
    type = list(string)
    default     = ["ca-central-1a", "ca-central-1b"]
}

variable "repo_name_patient" {
  default = "patient_micro_service"
}

variable "repo_name_appointment" {
  default = "appointment_micro_service"
}

variable "ecs_task_role" {
  default = "ecs_task_role_patient_appointment_service"
}

variable "cpu" {
  default     = 256
}

variable "memory" {
  default     = 512
}

variable "app_port" {
  default     = 3000
}

variable "desired_capacity" {
  default     = 1
}