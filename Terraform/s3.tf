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

# #---------------- public access
# resource "aws_s3_bucket_acl" "lab_backet_acl" {
#   bucket     = aws_s3_bucket.lab_bucket.id
#   acl        = "public-read"
#   depends_on = [aws_s3_bucket_ownership_controls.lab_bucket_control, aws_s3_bucket_public_access_block.example]
# }

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.lab_bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }
# #-------------------------------

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
  acl    = "public-read"
}
