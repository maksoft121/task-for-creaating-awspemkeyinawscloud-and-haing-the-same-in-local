terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.53.0"
    }
    
    tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }

     local = {
      source  = "hashicorp/local"
      version = "2.1.0"  # Specify the version you need
    }

  }
}
