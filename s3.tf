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