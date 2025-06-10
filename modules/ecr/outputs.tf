output "patient_arn" {
  value = aws_ecr_repository.patient_service.arn
}

output "appointment_arn" {
  value = aws_ecr_repository.appointment_service.arn
}

output "patient_registry_id" {
  value = aws_ecr_repository.patient_service.registry_id
}

output "appointment_registry_id" {
  value = aws_ecr_repository.appointment_service.registry_id
}

output "patient_repository_url" {
  value = aws_ecr_repository.patient_service.repository_url
}

output "appointment_repository_url" {
  value = aws_ecr_repository.appointment_service.repository_url
}