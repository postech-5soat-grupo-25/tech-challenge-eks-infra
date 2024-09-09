variable vpc_id {
  description = "Id da VPC na qual será criado o cluster"
  type        = string
  default     = "us-east-1"
}

variable subnets {
  description = "Ids das subnets para criar o cluster"
  type        = list(string)
  default     = []
}