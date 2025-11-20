// lib/controller/sale_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sale_model.dart';
import '../services/api_services.dart';

class SalesController {
  final ApiServices _api = ApiServices();
  static const String _baseUrl = "http://localhost:5059/api/Sales";
  static const String url = "Sales";

  // 1. Método para obtener todas las ventas
  Future<List<Sale>> obtenerTodasLasVentas() async {
    final uri = Uri.parse('$_baseUrl/Obtener_Ventas'); 

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // La API devuelve un arreglo de ventas en formato JSON
        final List<dynamic> jsonList = json.decode(response.body);

        // Convertimos cada mapa JSON en un objeto Sale
        return jsonList.map((json) => Sale.fromJson(json)).toList();
      } else {
        // Manejo de errores de respuesta de la API (404, 500, etc.)
        throw Exception('Error al obtener las ventas. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Manejo de errores de red o deserialización
      print('Error en la conexión o procesamiento de datos: $e');
      throw Exception('Fallo al cargar las ventas. Verifique su conexión o la URL de la API.');
    }
  }

  Future<bool> insertarVenta(Sale sale) async {
    final uri = Uri.parse("${_api.baseUrl}/$url/insertar_venta");
    try {
      final response = await http.post(
        uri,
        headers: _api.buildHeaders(),
        body: jsonEncode(sale.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("❌ Error insertarVenta: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Excepción insertarVenta: $e");
      return false;
    }
  }
}
