# td4/scripts/tofu/live/lambda-sample/main.tf

provider "aws" {
  region = "us-east-1"
}

# 1. Création de l'archive ZIP à partir du code JS (local)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/index.js"
  output_path = "${path.module}/lambda_function.zip"
}

# 2. Rôle IAM pour autoriser la Lambda à s'exécuter
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_tofu_test_fix"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 3. La Fonction Lambda elle-même
resource "aws_lambda_function" "test_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "tofu_test_hello_world"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}


# 4. API Gateway
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "tofu_test_api"
  protocol_type = "HTTP"
}

# 4a. Stage par défaut (Auto-deploy)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "$default"
  auto_deploy = true

  # CRUCIAL : On force le Stage à attendre que la Route soit créée.
  # Sans cela, le stage est déployé "vide" avant que la route n'existe -> 404
  depends_on = [aws_apigatewayv2_route.default_route]
}

# 4b. Intégration entre l'API et la Lambda
resource "aws_apigatewayv2_integration" "lambda_int" {
  api_id           = aws_apigatewayv2_api.lambda_api.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  description          = "Lambda Integration"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.test_lambda.invoke_arn
  payload_format_version = "2.0"
}

# 4c. Route par défaut (Capture tout le trafic)
# On remplace "$default" par "GET /"
# Cela signifie que SEULE la racine est gérée. Tout le reste donnera une 404.
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_int.id}"
}


# 5. Permission pour l'API Gateway d'invoquer la Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}

# SORTIE IMPORTANTE : C'est ce que le test va lire
output "api_endpoint" {
  value = aws_apigatewayv2_api.lambda_api.api_endpoint
}