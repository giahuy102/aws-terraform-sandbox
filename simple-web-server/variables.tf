variable "common_tags" {
  type        = map(string)
  description = "Common tags for all resources of this project"
  default = {
    "Project" = "Simple webserver"
  }
}
