# 1. Creación de la API HTTP 
resource "aws_apigatewayv2_api" "mi_api_gateway" {
  name          = "Mi_Api_GateWay"
  protocol_type = "HTTP"

  # Configuración de CORS según el tutorial del ava
  cors_configuration {
    # Access-Control-Allow-Origin: Usamos "*" para Desarrollo (Permite todo)
    allow_origins = ["*"]
    
    # Access-Control-Allow-Methods: Los verbos HTTP que usas
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    
    # Access-Control-Allow-Headers: Lista de headers que tu frontend enviará
    allow_headers = ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key"]
    
    # Access-Control-Max-Age: Basado en la imagen de la consola del tutorial
    max_age = 0
  }
}

# 2. Creación de la Integración (Apuntando a mindicador.cl)
resource "aws_apigatewayv2_integration" "integracion_mindicador" {
  api_id                 = aws_apigatewayv2_api.mi_api_gateway.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = "https://mindicador.cl/api"
  integration_method     = "GET"
  payload_format_version = "1.0"
}

# 3. Creación de la Ruta
resource "aws_apigatewayv2_route" "ruta_datos" {
  api_id    = aws_apigatewayv2_api.mi_api_gateway.id
  route_key = "GET /datos"
  target    = "integrations/${aws_apigatewayv2_integration.integracion_mindicador.id}"
}

# 4. Creación del Stage
resource "aws_apigatewayv2_stage" "stage_desarrollo" {
  api_id      = aws_apigatewayv2_api.mi_api_gateway.id
  name        = "Desarrollo"
  auto_deploy = true
}

# Output con la URL completa e incluye el Stage "Desarrollo"
output "api_endpoint" {
  value       = "${aws_apigatewayv2_api.mi_api_gateway.api_endpoint}/${aws_apigatewayv2_stage.stage_desarrollo.name}/datos"
  description = "URL final para probar en Postman o Curl"
}