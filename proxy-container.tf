# ECS task definition

resource "aws_efs_file_system" "fs" {
  creation_token = "${var.proxy_app_name}_fs_ct"

  tags = {
    Name = "${var.proxy_app_name}_fs"
  }
}

resource "aws_ecs_task_definition" "proxy_app" {
  family = "proxy-task"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  network_mode = "host"
  requires_compatibilities = ["EC2"]
  cpu = var.proxy_ec2_cpu
  memory = var.proxy_ec2_memory
  container_definitions = data.template_file.proxy_app.rendered

  volume {
    name      = "config"
    host_path = "/ecs/config"
  }

  volume {
    name      = "tailscale"
    host_path = "/ecs/tailscale"
  }

}

# ECS service
resource "aws_ecs_service" "proxy_app" {
  name = var.proxy_app_name
  cluster = aws_ecs_cluster.aws-ecs.id
  task_definition = aws_ecs_task_definition.proxy_app.arn
  desired_count = var.proxy_app_count
  launch_type = "EC2"
  load_balancer {
    target_group_arn = aws_alb_target_group.proxy_app.id
    container_name = var.proxy_app_name
    container_port = var.proxy_app_port
  }
  depends_on = [aws_alb_listener.front_end]
  tags = {
    Name = "${var.proxy_app_name}-proxy-ecs"
  }
}

# proxy container | proxy-container.tf
# container template
data "template_file" "proxy_app" {
  template = file("./proxy.json")
  vars = {
    app_name = var.proxy_app_name
    app_image = aws_ecr_repository.ecr_repo.repository_url
    app_port = var.proxy_app_port
    ec2_cpu = var.proxy_ec2_cpu
    ec2_memory = var.proxy_ec2_memory
    aws_region = var.aws_region
    cloudwatch_group = var.cloudwatch_group
    proxy_tz = var.proxy_tz
    proxy_validation  = var.proxy_validation
    proxy_duckdnstoken  = var.proxy_duckdnstoken
    proxy_subdomains  = var.proxy_subdomains
    proxy_url  = var.proxy_url
    proxy_email  = var.proxy_email
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name = var.proxy_registry  # Naming my repository
}
