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