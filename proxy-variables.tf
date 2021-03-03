# proxy container - proxy-variables.tf
variable "proxy_app_name" {
  description = "Name of Application Container"
  default = "proxy"
}
variable "proxy_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "proxy_app_image"
}
variable "proxy_registry" {
  description = "Amazon ECR name"
  default = "proxy_registry"
}
variable "proxy_app_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}
variable "proxy_app_count" {
  description = "Number of Docker containers to run"
  default = 1
}
variable "proxy_ec2_cpu" {
  description = "EC2 instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "1024"
}
variable "proxy_ec2_memory" {
  description = "EC2 instance memory to provision (in MiB)"
  default = "512"
}
variable "cloudwatch_group" {
  description = "CloudWatch group name."
  type = string
  default = "proxy_cloudwatch"
}
variable "proxy_tz"{
  description = "Proxy environment config variable for the TZ variable"
  type = string
}
variable "proxy_validation"{
  description = "Proxy environment config variable for the VALIDATION variable"
  type = string
}
variable "proxy_duckdnstoken"{
  description = "Proxy environment config variable for the DUCKDNSTOKEN variable"
  type = string
}
variable "proxy_subdomains"{
  description = "Proxy environment config variable for the SUBDOMAINS variable"
  type = string
}
variable "proxy_url"{
  description = "Proxy environment config variable for the URL variable"
  type = string
}
variable "proxy_email"{
  description = "Proxy environment config variable for the EMAIL variable"
  type = string
}