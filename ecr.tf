resource "aws_ecr_repository" "rust_ecr_repository" {
  name = "rust_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}


resource "aws_ecr_repository" "django_ecr_repository" {
  name = "django_api"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}