terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Network
resource "docker_network" "twitter_network" {
  name   = "twitter-network-tf"
  driver = "bridge"
}

# Volume for PostgreSQL
resource "docker_volume" "postgres_data" {
  name = "twitter-postgres-data-tf"
}

# PostgreSQL Database
resource "docker_image" "postgres" {
  name = "postgres:16-alpine"
}

resource "docker_container" "db" {
  name  = "twitter-db-tf"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

  ports {
    internal = 5432
    external = 5432
    ip       = "127.0.0.1"
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name = docker_network.twitter_network.name
    aliases = ["db"]
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.postgres_user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Backend API
resource "docker_image" "backend" {
  name         = var.backend_image
  keep_locally = false
}

resource "docker_container" "backend" {
  name  = "twitter-backend-tf"
  image = docker_image.backend.image_id

  env = [
    "DATABASE_URL=postgresql://${var.postgres_user}:${var.postgres_password}@db:5432/${var.postgres_db}",
    "DEBUG=true"
  ]

  ports {
    internal = 8000
    external = 8000
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name = docker_network.twitter_network.name
    aliases = ["backend"] 
  }

  depends_on = [docker_container.db]
}

# Frontend
resource "docker_image" "frontend" {
  name         = var.frontend_image
  keep_locally = false
}

resource "docker_container" "frontend" {
  name  = "twitter-frontend-tf"
  image = docker_image.frontend.image_id
  env = [
  "API_URL=${var.api_url}",
  "BACKEND_HOST=${var.backend_host}",
  "BACKEND_PORT=${var.backend_port}"
  ]

  ports {
    internal = 80
    external = 3001
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name = docker_network.twitter_network.name
  }

  depends_on = [docker_container.backend]
}
