locals {
  tags = {
    app = var.service
    env = var.environment
  }
}
