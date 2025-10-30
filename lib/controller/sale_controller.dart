// lib/controller/sale_controller.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/api_services.dart';
import '../model/sale_model.dart';

class SaleController {
  final ApiServices _api = ApiServices();
  static const String baseUrl = 'http://localhost:5059/api/Sales';

  Future<SaleResponseDTO?> insertarVenta(CreateSaleDTO sale) async {
    final uri = Uri.parse('$baseUrl/insertar_venta');

    try {
      final response = await http.post(
        uri,
        headers: {
          ..._api.buildHeaders(),
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(sale.toJson()),
      );

      if (kDebugMode) {
        print('Respuesta insertarVenta: ${response.statusCode}');
        print(response.body);
      }

      if (response.statusCode == 200) {
        return SaleResponseDTO.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error al registrar venta: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error insertarVenta: $e');
      rethrow;
    }
  }
}
