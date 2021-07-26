terraform {
  backend "s3" {
    bucket  = "rehambucket21"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}
