env = "dev"
aws_region = "eu-west-2"
python_v = "python3.8"

lambda_od = {
  "instances_id" = {
    name      = "instances_id"
    policy    = "instances_id"
    schedule  = "NA"
  }
  "list_buckets" = {
    name     = "list_buckets"
    policy   = "list_buckets"
    schedule = "NA"
  }
}

lambda_sc = {
  # "list_buckets" = {
  #   name     = "list_buckets"
  #   policy   = "list_buckets"
  #   schedule = "rate(60 minutes)"
  # }
}