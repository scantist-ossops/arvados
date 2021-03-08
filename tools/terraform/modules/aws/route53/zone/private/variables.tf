variable "zone_name"  {
  description = "Public zone to create"
  type        = string
}
variable "zone_config" {
  description = "Zone's config parameters"
  type    = map
  default = {}
}
variable "tags"  {
  type = map 
  default = {}
}
