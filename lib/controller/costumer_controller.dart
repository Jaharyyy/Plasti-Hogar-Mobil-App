import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/costumer_model.dart';
import '../services/api_services.dart';

class CustomerController {
  final ApiServices _api = ApiServices();
  static const String baseUrl = "http://localhost:5059/api/Customers/";

  // GET - Clientes Activos
  Future<List<Customer>> getActiveCustomers() async {
    final uri = Uri.parse('${baseUrl}obtenerClientesActivos');
    final response = await http.get(uri, headers: _api.buildHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Customer.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener clientes activos: ${response.statusCode}');
    }
  }

  // GET - Clientes Inactivos
  Future<List<Customer>> getInactiveCustomers() async {
    final uri = Uri.parse('${baseUrl}obtenerClientesInactivos');
    final response = await http.get(uri, headers: _api.buildHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Customer.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener clientes inactivos: ${response.statusCode}');
    }
  }

  // POST - Insertar cliente
  Future<bool> insertCustomer(Customer customer) async {
    final uri = Uri.parse('${baseUrl}insertarClientes');
    final response = await http.post(
      uri,
      headers: _api.buildHeaders(),
      body: jsonEncode(customer.toJson()),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) == true;
    } else {
      throw Exception('Error al insertar cliente: ${response.body}');
    }
  }

  // PUT - Activar cliente
  Future<bool> activateCustomer(int id) async {
    final uri = Uri.parse('${baseUrl}activarCliente/$id');
    final response = await http.put(uri, headers: _api.buildHeaders());
    return response.statusCode == 200;
  }

  // PUT - Desactivar cliente
  Future<bool> deactivateCustomer(int id) async {
    final uri = Uri.parse('${baseUrl}desactivarCliente/$id');
    final response = await http.put(uri, headers: _api.buildHeaders());
    return response.statusCode == 200;
  }
}
