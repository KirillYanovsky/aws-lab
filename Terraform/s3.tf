resource "aws_s3_bucket" "lab_bucket" {
  bucket = "bucket-for-aws-lab"

  tags = {
    Name      = "Lab-S3"
    Terraform = "true"
  }
}

resource "aws_s3_bucket_ownership_controls" "lab_bucket_control" {
  bucket = aws_s3_bucket.lab_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lab_backet_acl" {
  bucket     = aws_s3_bucket.lab_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.lab_bucket_control]
}

resource "aws_s3_bucket_versioning" "lab_backet_versioning" {
  bucket = aws_s3_bucket.lab_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "lab_object" {
  bucket = aws_s3_bucket.lab_bucket.bucket
  key    = "aws-lab/logo1.jpeg"
  source = "../files/logo1.jpeg"
}
