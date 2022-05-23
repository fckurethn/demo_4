resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "./modules/init-build/build.sh"

    environment = {
      region      = var.region
      ecr_url     = aws_ecr_repository.demo.repository_url
      registry_id = aws_ecr_repository.demo.registry_id
      github_repo = var.github_repo
      app_tag     = var.app_tag
      env         = var.env
    }
  }
}
