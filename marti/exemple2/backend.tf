# Emmagatzemant per l'estat dels fitxers dintre del s3 bucket.
terraform {
  backend "s3" {
    bucket                  = "wordpress-pildora5-01-02"
    region                  = "us-east-1"
    key                     = "wordpress-3tier/terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials"
  }
}
