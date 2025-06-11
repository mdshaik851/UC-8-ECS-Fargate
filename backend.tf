terraform {
  backend "s3" {
    bucket       = "uc-6-lambda-ec2"
    key          = "terraform.tfstate"
    region       = "ca-central-1"
    encrypt      = true
    use_lockfile = true
  }
}