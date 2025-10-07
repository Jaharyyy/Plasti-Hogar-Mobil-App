import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../model/domain_model.dart';
import '../model/type_registry.dart';

class ApiServices {
  // ==============================
  // ✅ SINGLETON
  // ==============================
  static final ApiServices _instance = ApiServices._internal();
  factory ApiServices() => _instance;
  ApiServices._internal();

  // ==============================
  // 🔗 CONFIGURACIÓN BASE
  // ==============================
  final String baseUrl = "http://localhost:5059/api"; // Cambia si usas otro puerto o dominio
  String? _bearerToken; // Token JWT actual

  // ==============================
  // 🔑 GESTIÓN DE TOKEN
  // ==============================
  void setBearerToken(String token) {
    _bearerToken = token;
    if (kDebugMode) print('🔐 Token guardado: $_bearerToken');
  }

  Map<String, String> buildHeaders() {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (_bearerToken != null && _bearerToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_bearerToken';
    }
    if (kDebugMode) print('🧾 Headers enviados: $headers');
    return headers;
  }

  // ==============================
  // 📤 POST (para Login o Insertar)
  // ==============================
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = endpoint.startsWith('http')
        ? Uri.parse(endpoint)
        : Uri.parse('$baseUrl/$endpoint');

    final body = jsonEncode(data);

    try {
      final response = await http.post(
        url,
        headers: buildHeaders(),
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('🚫 No autorizado o credenciales inválidas.');
      } else {
        throw Exception('⚠️ Error de servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error POST $endpoint: $e');
      throw Exception('Fallo la conexión con el servidor.');
    }
  }

  // ==============================
  // 📥 GET genérico
  // ==============================
  Future<T> get<T extends DomainModel>({
    required T model,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl${model.getDomain()}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: buildHeaders());
    return _handleResponse<T>(response, model.runtimeType.toString());
  }

  // ==============================
  // 📋 GET lista (para catálogos)
  // ==============================
  Future<List<T>> getList<T extends DomainModel>({
    required T model,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl${model.getDomain()}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: buildHeaders());

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json is List) {
        return json
            .map((item) =>
                _deserialize<T>(item, model.runtimeType.toString()))
            .toList();
      } else {
        throw Exception('Se esperaba una lista, recibido: $json');
      }
    } else if (response.statusCode == 401) {
      throw Exception('🚫 No autorizado (token faltante o expirado)');
    } else {
      throw Exception('⚠️ Error GET ${response.statusCode}');
    }
  }

  // ==============================
  // ✏️ PUT
  // ==============================
  Future<void> put({required DomainModel model}) async {
    final response = await http.put(
      Uri.parse('$baseUrl${model.getDomain()}'),
      headers: buildHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('PUT falló: ${response.body}');
    }
  }

  // ==============================
  // ❌ DELETE
  // ==============================
  Future<void> delete({required DomainModel model}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl${model.getDomain()}'),
      headers: buildHeaders(),
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('DELETE falló: ${response.body}');
    }
  }

  // ==============================
  // 🧠 Manejo genérico de respuesta
  // ==============================
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
    } else if (response.statusCode == 401) {
      throw Exception('🚫 No autorizado (token inválido o faltante)');
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  // ==============================
  // 🧩 Conversión dinámica
  // ==============================
  Map<String, dynamic> _castMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map<dynamic, dynamic>) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw Exception('No se puede convertir a Map<String, dynamic>: $value');
  }

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

// ==================================================
// 🔹 Métodos públicos de soporte (GET / PUT simples)
// ==================================================

// 🔸 GET sin tipo genérico (retorna el body como String)
Future<String> getRaw(Uri uri) async {
  final response = await http.get(uri, headers: buildHeaders());

  if (response.statusCode == 200) {
    return response.body;
  } else if (response.statusCode == 401) {
    throw Exception('🚫 No autorizado — token inválido o expirado.');
  } else {
    throw Exception('⚠️ Error GET ${uri.path}: ${response.statusCode}');
  }
}

// 🔸 PUT sin body (para activar/desactivar registros)
Future<bool> putRaw(Uri uri) async {
  final response = await http.put(uri, headers: buildHeaders());

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception('🚫 No autorizado — token inválido o expirado.');
  } else {
    throw Exception('⚠️ Error PUT ${uri.path}: ${response.statusCode}');
  }
}



}

