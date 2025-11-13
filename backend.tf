terraform {
  backend "s3" {
    bucket         = "terraform-remote-state-amankothiyal"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
