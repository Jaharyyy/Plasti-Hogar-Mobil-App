import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/costumer_model.dart';
import '../services/api_services.dart';

class CustomerController {
  final ApiServices _api = ApiServices();

  // 🔹 Base URL (ajústala según tu backend)
  static const String _baseUrl = "http://localhost:5059/api/Customers/";

  // ============================================
  // 🔹 OBTENER CLIENTES ACTIVOS
  // ============================================
  Future<List<Customer>> getActiveCustomers() async {
    final uri = Uri.parse('${_baseUrl}obtenerClientesActivos');
    try {
      final response = await http.get(uri, headers: _api.buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Customer.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        // No hay datos
        return [];
      } else {
        throw Exception(
            '⚠️ Error GET /obtenerClientesActivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('❌ Error al obtener clientes activos: $e');
    }
  }

  // ============================================
  // 🔹 OBTENER CLIENTES INACTIVOS
  // ============================================
  Future<List<Customer>> getInactiveCustomers() async {
    final uri = Uri.parse('${_baseUrl}obtenerClientesInactivos');
    try {
      final response = await http.get(uri, headers: _api.buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Customer.fromJson(e)).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        throw Exception(
            '⚠️ Error GET /obtenerClientesInactivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('❌ Error al obtener clientes inactivos: $e');
    }
  }

  // ============================================
  // 🔹 INSERTAR NUEVO CLIENTE
  // ============================================
  Future<bool> insertCustomer(Customer customer) async {
    final uri = Uri.parse('${_baseUrl}insertarClientes');

    try {
      final response = await http.post(
        uri,
        headers: _api.buildHeaders(),
        body: jsonEncode(customer.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // API devuelve true/false
        final dynamic data = jsonDecode(response.body);
        if (data is bool) return data;
        if (data is Map && data['result'] == true) return true;
        return true;
      } else {
        throw Exception(
            '⚠️ Error POST /insertarClientes: ${response.statusCode} → ${response.body}');
      }
    } catch (e) {
      throw Exception('❌ Error al insertar cliente: $e');
    }
  }

// 🔹 PUT - Activar cliente
// baseUrl debe ser SIN / al final:
// static const String baseUrl = "http://localhost:5059/api/Customers";

// PUT - Activar
Future<bool> activateCustomer(int id) async {
  final uri = Uri.parse('${_baseUrl}activarCliente/$id');
  if (id <= 0) throw Exception('ID inválido al activar ($id)');
  final headers = Map<String, String>.from(_api.buildHeaders());
  headers.remove('Content-Type'); // no hay body

  final resp = await http.put(uri, headers: headers);
  if (resp.statusCode == 200) {
    return resp.body.trim().toLowerCase() == 'true';
  }
  throw Exception('PUT activarCliente: ${resp.statusCode} → ${resp.body}');
}

// PUT - Desactivar
Future<bool> deactivateCustomer(int id) async {
  final uri = Uri.parse('${_baseUrl}desactivarCliente/$id');
  if (id <= 0) throw Exception('ID inválido al desactivar ($id)');
  final headers = Map<String, String>.from(_api.buildHeaders());
  headers.remove('Content-Type'); // no hay body

  final resp = await http.put(uri, headers: headers);
  if (resp.statusCode == 200) {
    return resp.body.trim().toLowerCase() == 'true';
  }
  throw Exception('PUT desactivarCliente: ${resp.statusCode} → ${resp.body}');
}
}