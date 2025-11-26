run "deploy" {
  command = apply
}

run "validate" {
  command = apply

  module {
    source = "../../modules/test-endpoint"
  }

  variables {
    endpoint = run.deploy.api_endpoint
  }

  assert {
    condition     = data.http.test_endpoint.status_code == 200
    error_message = "Unexpected status: ${data.http.test_endpoint.status_code}"
  }

  assert {
    condition     = jsondecode(data.http.test_endpoint.response_body).message == "Hello, JSON!"
    error_message = "JSON content mismatch. Received: ${data.http.test_endpoint.response_body}"
  }
}

run "validate_404" {
  command = apply

  module {
    source = "../../modules/test-endpoint"
  }

  variables {
    # On ajoute un chemin '/missing' qui n'est pas défini dans l'API Gateway
    endpoint = "${run.deploy.api_endpoint}/missing"
  }

  # On s'attend à recevoir une erreur 404 Not Found
  assert {
    condition     = data.http.test_endpoint.status_code == 404
    error_message = "Expected 404 Not Found for non-existent resource, but got: ${data.http.test_endpoint.status_code}"
  }
}