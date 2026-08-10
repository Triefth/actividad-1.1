# 1. Creación de la API HTTP
resource "aws_apigatewayv2_api" "mi_api_gateway" {
  name          = "Mi_Api_GateWay"
  protocol_type = "HTTP"
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