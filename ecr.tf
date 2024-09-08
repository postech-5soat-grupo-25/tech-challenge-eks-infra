resource "aws_ecr_repository" "pedido_produto_api_repository" {
  name = "pedido_produto_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}

resource "aws_ecr_repository" "pagamentos_api_repository" {
  name = "pagamentos_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}

resource "aws_ecr_repository" "mock_pagamentos_api_repository" {
  name = "mock_pagamentos_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}