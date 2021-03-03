# ECS cluster variables | ecs-cluster-variables.tf
variable "cluster_runner_type" {
  type = string
  description = "EC2 instance type of ECS Cluster Runner"
  default = "t2.micro"
}
variable "cluster_runner_count" {
  type = string
  description = "Number of EC2 instances for ECS Cluster Runner" 
  default = "1"
}