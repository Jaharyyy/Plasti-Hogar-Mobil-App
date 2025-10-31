import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';
import '../services/api_services.dart';

class ProductController {
  final ApiServices _api = ApiServices();

  // 🔹 Base URL — ajusta si tu backend cambia
  static const String _baseUrl = "http://localhost:5059/api/Products/";

  // ============================================
  // 🔹 OBTENER PRODUCTOS ACTIVOS
  // ============================================
  Future<List<Product>> obtenerProductosActivos() async {
    final uri = Uri.parse('${_baseUrl}obtenerProductosActivos');

    try {
      final response = await http.get(uri, headers: _api.buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Product.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        // No hay productos activos
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('🚫 No autorizado: el token no es válido o expiró.');
      } else {
        throw Exception(
            '⚠️ Error GET /obtenerProductosActivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('❌ Error al obtener productos activos: $e');
    }
  }
}
