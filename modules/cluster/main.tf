resource "aws_ecr_repository" "demo" {
  name                 = "demo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "./modules/cluster/build.sh"

    environment = {
      region      = var.region
      ecr_url     = aws_ecr_repository.demo.repository_url
      registry_id = aws_ecr_repository.demo.registry_id
      github_url  = var.github_url
      app_tag     = var.app_tag
    }
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "tf_cluster"
}


resource "aws_ecs_task_definition" "demo" {
  family                   = "demo"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  container_definitions    = data.template_file.task_definition_template.rendered
}

data "template_file" "task_definition_template" {
  template = templatefile("./modules/cluster/task_definition.json.tpl", {
    ecr_url = aws_ecr_repository.demo.repository_url,
    app_tag = var.app_tag
  })
}

resource "aws_ecs_service" "demo" {
  name                 = "demo"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  task_definition      = aws_ecs_task_definition.demo.arn
  desired_count        = 2
  force_new_deployment = true

  load_balancer {
    target_group_arn = var.tf_tg_arn
    container_name   = aws_ecs_task_definition.demo.family
    container_port   = 5000
  }
}
