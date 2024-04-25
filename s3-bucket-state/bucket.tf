# Creació del bucket S3 privat. Aquest guardará l'estat del terraform.
resource "aws_s3_bucket" "tfstate" {
  bucket        = "wordpress-pildora5"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tfstate_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership]
  bucket     = aws_s3_bucket.tfstate.id
  acl        = "private"
}

# Afegim versionat del bucket en cas de necesitar tornar enrere.
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}
