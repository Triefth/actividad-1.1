# 1. Creación de la API HTTP
resource "aws_apigatewayv2_api" "mi_api_gateway" {
  name          = "Mi_Api_GateWay"
  protocol_type = "HTTP"
}

# 2. Creación de la Integración (Apuntando a la API de mindicador.cl)
resource "aws_apigatewayv2_integration" "integracion_mindicador" {
  api_id             = aws_apigatewayv2_api.mi_api_gateway.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "https://mindicador.cl/api"
  integration_method = "GET"
}

# 3. Creación de la Ruta asociada al método GET y a la integración
resource "aws_apigatewayv2_route" "ruta_datos" {
  api_id    = aws_apigatewayv2_api.mi_api_gateway.id
  route_key = "GET /datos"
  target    = "integrations/${aws_apigatewayv2_integration.integracion_mindicador.id}"
}

# 4. Creación del Stage y despliegue automático
resource "aws_apigatewayv2_stage" "stage_desarrollo" {
  api_id      = aws_apigatewayv2_api.mi_api_gateway.id
  name        = "Desarrollo"
  auto_deploy = true
}

# (Opcional) Mostrar la URL final de invocación en la consola al terminar
output "api_endpoint" {
  value = "${aws_apigatewayv2_api.mi_api_gateway.api_endpoint}/datos"
}