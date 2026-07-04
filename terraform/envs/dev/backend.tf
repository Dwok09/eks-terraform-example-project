terraform {
  backend "s3" {
    bucket       = "terraform-state-8907904"
    key          = "dev"
    region       = "us-east-1"
    use_lockfile = true
  }
}
