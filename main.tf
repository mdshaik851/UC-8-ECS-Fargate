terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
 }

  }
  required_version = ">= 1.10.0"
}

module "vpc_creation" {
  source = "./modules/vpc"
  region = var.region
  vpc_cidr = var.vpc_cidr
  availability_zone = var.availability_zone
  public_subnet = var.public_subnet
  private_subnet = var.private_subnet
}

module "ecr_repo_creation" {
  source = "./modules/ecr"
  repo_name_patient = var.repo_name_patient
  repo_name_appointment = var.repo_name_appointment
}

module "iam_task_execution_role_creation" {
  source = "./modules/iamrole"
  ecs_task_role = var.ecs_task_role
}

module "alb" {
  source = "./modules/alb"
  security_groups_id_alb = module.vpc_creation.security_group_alb
  subnet_ids = module.vpc_creation.public_subnet_id
  tg_grp_protocal = "HTTP"
  vpc_id = module.vpc_creation.vpc_id_details
}

module "ecs_creation" {
  source = "./modules/ecs"
  container_cpu = var.cpu
  container_memory = var.memory
  task_execution_role_arn = module.iam_task_execution_role_creation.task_execution_role_arn
  task_role_arn = module.iam_task_execution_role_creation.ecs_task_role_arn
  ecr_patient_repo_url = module.ecr_repo_creation.patient_repository_url
  app_port = var.app_port
  ecr_appointment_repo_url = module.ecr_repo_creation.appointment_repository_url
  desired_capacity = var.desired_capacity
  ecs_security_group_id = module.vpc_creation.security_group_ecs_farget
  private_subnets = module.vpc_creation.private_subnet_ids
  target_group_arns = module.alb.target_group_arns
  region = var.region
}

module "creation_cloud_wtach_alarm" {
  source = "./modules/cloudwatch"
  cluster_name = module.ecs_creation.cluster_name
}