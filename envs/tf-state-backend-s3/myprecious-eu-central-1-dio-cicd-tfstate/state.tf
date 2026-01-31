terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "dio-cicd-tfstate"
    key            = "tf-state-backend-s3/myprecious-eu-central-1-dio-cicd-tfstate/terraform.tfstate"
    dynamodb_table = "dio-cicd-tfstate"
    encrypt        = "true"
  }
}
