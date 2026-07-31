terraform {
  backend "s3" {
    bucket = "moc-tf-state"
    key    = "open-accelerator-infra-admin.json"
    region = "us-east-1"
  }
}
