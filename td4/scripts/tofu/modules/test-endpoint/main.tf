 # main.tf in test-endpoint module 
terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }
    # On ajoute le provider 'time' pour pouvoir faire une pause
    time = {
      source = "hashicorp/time"
    }
  }
}

variable "endpoint" {
  description = "The endpoint to test"
  type        = string
}

# Ressource pour attendre 10 secondes avant de tester
# Cela laisse le temps à l'API Gateway de se propager (DNS, Routes)
resource "time_sleep" "wait_for_api" {
  create_duration = "10s"
}

data "http" "test_endpoint" {
  url = var.endpoint

  # On garde le retry pour les erreurs 5xx ou timeout, c'est toujours utile
  retry {
    attempts     = 5
    min_delay_ms = 1000
    max_delay_ms = 5000
  }

  # CRUCIAL : On ne lance la requête HTTP qu'après la fin du timer
  depends_on = [time_sleep.wait_for_api]
}

output "status_code" {
  value = data.http.test_endpoint.status_code
}

output "response_body" {
  value = data.http.test_endpoint.response_body
}