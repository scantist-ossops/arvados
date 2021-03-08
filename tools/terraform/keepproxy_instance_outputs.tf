output "keepproxy_id" {
  value = module.keepproxy.id
}
output "keepproxy_private_dns_names" {
  value = module.keepproxy.private_dns
}
output "keepproxy_private_ip" {
  value = module.keepproxy.private_ip
}
output "keepproxy_private_eni_id" {
  value = aws_network_interface.keepproxy.id
}
