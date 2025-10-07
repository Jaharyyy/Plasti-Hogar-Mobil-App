import 'dart:convert';
import '../model/costumer_model.dart';
import '../services/api_services.dart';
import 'package:flutter/foundation.dart';

class CustomerController {
  final ApiServices _api = ApiServices();
  static const String _endpointBase = "Customers"; // 🔹 sin slash al final

  // 📥 Clientes Activos
  Future<List<Customer>> getActiveCustomers() async {
    try {
      final uri = Uri.parse('${_api.baseUrl}/$_endpointBase/obtenerClientesActivos'); // ✅ sin doble slash
      final response = await _api.getRaw(uri);

      final List<dynamic> data = jsonDecode(response);
      return data.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) print('❌ Error al obtener clientes activos: $e');
      rethrow;
    }
  }

  // 📥 Clientes Inactivos
  Future<List<Customer>> getInactiveCustomers() async {
    try {
      final uri = Uri.parse('${_api.baseUrl}/$_endpointBase/obtenerClientesInactivos'); // ✅ igual corregido
      final response = await _api.getRaw(uri);

      final List<dynamic> data = jsonDecode(response);
      return data.map((e) => Customer.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) print('❌ Error al obtener clientes inactivos: $e');
      rethrow;
    }
  }

  // ➕ Insertar cliente
  Future<bool> insertCustomer(Customer customer) async {
    try {
      final endpoint = '$_endpointBase/insertarClientes';
      final result = await _api.post(endpoint, customer.toJson());
      return result == true;
    } catch (e) {
      if (kDebugMode) print('❌ Error al insertar cliente: $e');
      rethrow;
    }
  }

  // 🔓 Activar cliente
  Future<bool> activateCustomer(int id) async {
    try {
      final uri = Uri.parse('${_api.baseUrl}/$_endpointBase/activarCliente/$id');
      final response = await _api.putRaw(uri);
      return response == true;
    } catch (e) {
      if (kDebugMode) print('❌ Error al activar cliente: $e');
      rethrow;
    }
  }

  // 🔒 Desactivar cliente
  Future<bool> deactivateCustomer(int id) async {
    try {
      final uri = Uri.parse('${_api.baseUrl}/$_endpointBase/desactivarCliente/$id');
      final response = await _api.putRaw(uri);
      return response == true;
    } catch (e) {
      if (kDebugMode) print('❌ Error al desactivar cliente: $e');
      rethrow;
    }
  }
}

