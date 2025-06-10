output "dns_alb_patient_appointment_service" {
  value = aws_lb.demo_alb_uc8.dns_name
}

output "patient_service_target_group_arn" {
  value       = aws_lb_target_group.patient_tg_group.arn
}

output "appointment_service_target_group_arn" {
  value       = aws_lb_target_group.appointment_tg_group.arn
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value = {
    patient_service     = aws_lb_target_group.patient_tg_group.arn
    appointment_service = aws_lb_target_group.appointment_tg_group.arn
  }
}