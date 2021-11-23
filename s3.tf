resource "aws_s3_bucket" "markov-bucket" {
  bucket = "fmarkov-netology"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "my-picture" {
  bucket = aws_s3_bucket.markov-bucket.id
  key = "markov"
  source = "markov.jpeg"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "gitlab" {
  bucket = aws_s3_bucket.markov-bucket.id
  key = "gitlab"
  source = "gitlab.tar.gz.gpg"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "runner" {
  bucket = aws_s3_bucket.markov-bucket.id
  key = "runner"
  source = "runner.tar.gz.gpg"
  acl = "public-read"
}

resource "aws_s3_bucket_object" "registry" {
  bucket = aws_s3_bucket.markov-bucket.id
  key = "registry"
  source = "registry.tar.gz.gpg"
  acl = "public-read"
}