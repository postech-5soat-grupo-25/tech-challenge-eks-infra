resource "aws_ecr_repository" "ecr_repository" {
  name = "tech_challenge_ecr"
  image_tag_mutability = "MUTABLE" # Optional: Specify MUTABLE or IMMUTABLE
}