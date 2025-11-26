provider "aws" { 
  region = "us-east-2"
}

module "sample_app" {
  source = "../../modules/ec2-instance"

  count  = 2  # Number of instances
  ami_id = "ami-0b6c1518053a48192"
  name   = "sample-app-tofu-${count.index + 1}"  # Unique name per instance
  port   = 8080 + count.index                   # Optional: unique port per instance
}
