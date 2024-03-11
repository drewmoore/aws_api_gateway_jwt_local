# Set by environment variables prefixed with "TF_VAR_"

# Must be unique per developer using the same AWS account so that there aren't conflicts between resources
variable "environment" {}

# The name of your service or application
variable "service" {}

variable "local_proxy_base_url" {
  description = "The ngrok public url that routes traffic to your local machine. This service is created when applying docker-compose."

  validation {
    condition     = length(var.local_proxy_base_url) > 0
    error_message = "No value found. The service is probably still starting, so you can usually just try again after a few seconds before debbuging."
  }
}
