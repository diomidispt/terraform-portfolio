terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "dio-cicd-tfstate"
    key            = "dio-github-actions-ci-role/myprecious-eu-central-1-dio-github-actions-ci-role/terraform.tfstate"
    dynamodb_table = "dio-cicd-tfstate"
    encrypt        = "true"
  }
}
