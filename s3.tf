#Define Buckets
resource "aws_s3_bucket" "exposedbucket" {
  bucket = "${var.victim_company}accidentlyexposed"
  tags = {
    Name        = "Exposed Bucket"
    env = "Dev"
    Owner = var.owner
  }
}

# Policies
resource "aws_s3_bucket_policy" "open_policy" {
  bucket = aws_s3_bucket.exposedbucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

data "aws_iam_policy_document" "allow_access" {
  statement {

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_cloudtrail" "secure" {
  name           = "secure"
  s3_bucket_name = aws_s3_bucket.exposedbucket.id
  enable_logging = false
}

resource "aws_s3_bucket_acl" "exposedbucket_acl" {
  bucket = aws_s3_bucket.exposedbucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.exposedbucket.id
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
