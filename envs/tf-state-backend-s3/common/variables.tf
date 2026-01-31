variable "account" {
  description = "An object containing info for the target AWS account"
  type = object({
    id    = string
    name  = string
    alias = string
  })
}

variable "region" {
  description = "An object containing info for the target AWS region"
  type = object({
    id   = string
    name = string
  })
}

variable "environment_name" {
  description = "The name of the environment for the resources. The S3 bucket and DynamoDB table will have this name"
  type        = string
}