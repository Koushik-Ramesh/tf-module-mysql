# Reads the information from remote state file
data "terraform_remote_state" "vpc" {
   backend = "s3"
   config = {
       bucket = "koushik-bucket"
      key = "vpc/${var.ENV}/terraform.tfstate"
       region = "us-east-1"
   }
 }

