resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "./modules/init-build/build.sh"

    environment = {
      region      = var.region
      ecr_url     = var.repository_url
      registry_id = var.registry_id
      github_repo = var.github_repo
      app_tag     = var.app_tag
      env         = var.env
    }
  }
}
