resource "aws_ecr_repository" "patient_service" {
  name                 = var.repo_name_patient
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "patient_service"
  }
}

resource "aws_ecr_repository" "appointment_service" {
  name                 = var.repo_name_appointment
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
    tags = {
    Name        = "appointment_service"
  }
}