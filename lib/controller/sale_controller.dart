// lib/controller/sale_controller.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/sale_model.dart';
import '../services/api_services.dart';

class SalesController {
  final ApiServices _api = ApiServices();
  static const String url = "Sales";

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
