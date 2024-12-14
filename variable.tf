variable "region" {
    description = "AWS region"
    default = "us-east-1"
  
}
variable "project_tags" {
    description = "default tags for resources"
    default = {
        env = "dev"
        team = "cloud"
        created_by = "Joseph Lucky"
    }
  
}