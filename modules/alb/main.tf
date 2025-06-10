############ Creation of Application Load Balancer for Open Project  ###############
resource "aws_lb" "demo_alb_uc8" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [var.security_groups_id_alb]
  subnets            = var.subnet_ids
}

#Application is running on which port that port we need to create the target group
resource "aws_lb_target_group" "patient_tg_group" {
  name     = "patient-tg-group"
  port     = 3000
  protocol = var.tg_grp_protocal
  vpc_id   = var.vpc_id
  target_type = "ip"
   tags = {
    Name        = "patient-tg"
  }
}

# Target Group for Appointment Service
resource "aws_lb_target_group" "appointment_tg_group" {
  name     = "appointment-tg-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  tags = {
    Service     = "appointment-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "http_listerner" {
  load_balancer_arn = aws_lb.demo_alb_uc8.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Healthcare Application - Try /patients or /appointments"
      status_code  = "404"
    }
  }

  tags = {
    Name        = "alb-listener"
  }
}

# Listener Rule for Patient Service
resource "aws_lb_listener_rule" "patient_service" {
  listener_arn = aws_lb_listener.http_listerner.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient_tg_group.arn
  }

  condition {
    path_pattern {
      values = ["/patients*"]
    }
  }

  tags = {
    Name        = "patient-listener-rule"
  }
}

# Listener Rule for Appointment Service
resource "aws_lb_listener_rule" "appointment_service" {
  listener_arn = aws_lb_listener.http_listerner.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appointment_tg_group.arn
  }

  condition {
    path_pattern {
      values = ["/appointments*"]
    }
  }

  tags = {
    Name        = "appointment-listener-rule"
  }
}