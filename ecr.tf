resource "aws_ecr_repository" "rust_ecr_repository" {
  name = "pedido_produto_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}

resource "aws_ecr_repository" "rust_ecr_repository" {
  name = "pagamentos_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}

resource "aws_ecr_repository" "django_ecr_repository" {
  name = "mock_pagamentos_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}