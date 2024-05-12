resource "aws_ecr_repository" "ecr_repository" {
  name = "rust_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}


resource "aws_ecr_repository" "ecr_repository" {
  name = "django_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}