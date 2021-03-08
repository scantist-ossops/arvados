output "keypair_name" {
  description = "Name of the SSH keypair applied to the instances."
  value       = module.keypair.name
}
