variable "postgres_user" {
  description = "PostgreSQL user"
  type        = string
  default     = "postgres"
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "twitter_clone"
}

variable "backend_image" {
  description = "Backend Docker image from GHCR"
  type        = string
  default     = "ghcr.io/bwoogmy/devops-backend:latest"
}

variable "frontend_image" {
  description = "Frontend Docker image from GHCR"
  type        = string
  default     = "ghcr.io/bwoogmy/devops-frontend:latest"
}

variable "api_url" {
  description = "API URL for frontend"
  type        = string
  default     = "http://localhost:8000/api/v1"
}

variable "backend_host" {
  description = "Backend hostname for nginx proxy"
  type        = string
  default     = "backend"
}

variable "backend_port" {
  description = "Backend port"
  type        = number
  default     = 8000
}
