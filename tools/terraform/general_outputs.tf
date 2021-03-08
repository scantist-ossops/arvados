### GENERAL
output "aws_region" {
  value = var.aws_region
}
output "aws_profile" {
  value = var.aws_profile
}
output "environment" {
  value = var.environment
}
output "namespace" {
  value = var.namespace
}
output "resource_tags" {
  value = local.resource_tags
}
output "ami" {
  value = var.ami
}
