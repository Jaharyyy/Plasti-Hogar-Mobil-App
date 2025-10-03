import 'dart:convert';
import '../model/domain_model.dart';
import 'package:http/http.dart' as http;
import '../model/type_registry.dart';
import 'services_config.dart';

class ApiServices {
  final String baseUrl = "http://localhost:5059/api"; // Emulador Android

  String? _bearerToken; // 🔑 Aquí guardamos el token

  // Método para asignar el token después del login
  void setBearerToken(String token) {
    _bearerToken = token;
  }

  // === GET ===
  Future<T> get<T extends DomainModel>({
    required T model,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl${model.getDomain()}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: _buildHeaders(),
    );

    return _handleResponse<T>(response, model.runtimeType.toString());
  }

  // === POST ===
  Future<T> post<T extends DomainModel>({required T model}) async {
    final response = await http.post(
      Uri.parse('$baseUrl${model.getDomain()}'),
      headers: _buildHeaders(),
      body: jsonEncode(model.toJson()),
    );

    return _handleResponse<T>(response, model.runtimeType.toString());
  }

  // === PUT ===
  Future<void> put({required DomainModel model}) async {
    final response = await http.put(
      Uri.parse('$baseUrl${model.getDomain()}'),
      headers: _buildHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('PUT falló: ${response.body}');
    }
  }

  // === DELETE ===
  Future<void> delete({required DomainModel model}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl${model.getDomain()}'),
      headers: _buildHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('DELETE falló: ${response.body}');
    }
  }

  // Construye headers con Bearer si existe
  Map<String, String> _buildHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_bearerToken != null) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }
    return headers;
  }

  // Manejo común de respuesta
  Future<T> _handleResponse<T extends DomainModel>(
    http.Response response,
    String typeName,
  ) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final dynamic decodedJson = jsonDecode(response.body);
      if (decodedJson is List) {
        if (decodedJson.isNotEmpty) {
          final map = _castMap(decodedJson[0]);
          return TypeRegistry.create<T>(typeName, map);
        } else {
          throw Exception('Lista vacía recibida');
        }
      } else if (decodedJson is Map) {
        final map = _castMap(decodedJson);
        return TypeRegistry.create<T>(typeName, map);
      } else {
        throw Exception('Formato inesperado: esperado Map o List');
      }
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Map<String, dynamic> _castMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map<dynamic, dynamic>) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw Exception('No se puede convertir a Map<String, dynamic>: $value');
  }

  // === GET Lista de objetos ===
  Future<List<T>> getList<T extends DomainModel>({
    required T model,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl${model.getDomain()}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: _buildHeaders(),
    );

    final json = jsonDecode(response.body);
    if (json is List) {
      return json
          .map((item) =>
              _deserialize<T>(item, model.runtimeType.toString()))
          .toList();
    } else {
      throw Exception('Se esperaba una lista, recibido: $json');
    }
  }

  // === Método interno para deserializar un solo objeto ===
  T _deserialize<T extends DomainModel>(dynamic json, String typeName) {
    if (json is Map<dynamic, dynamic>) {
      final map = json.cast<String, dynamic>();
      return TypeRegistry.create<T>(typeName, map);
    } else if (json is Map<String, dynamic>) {
      return TypeRegistry.create<T>(typeName, json);
    } else {
      throw Exception('No se puede deserializar: $json');
    }
  }
}
