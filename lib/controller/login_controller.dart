import 'package:flutter/foundation.dart';
import 'package:plastihogar_flutter/model/auth_response.dart';
import 'package:plastihogar_flutter/services/api_services.dart';

class LoginController {
  final ApiServices _apiService = ApiServices();

  Future<AuthResponse?> performLogin(String nombreUsuario, String password) async {
    final Map<String, dynamic> loginData = {
      'nombre_Usuario': nombreUsuario,
      'passwordHash': password,
    };

    try {
      // ✅ endpoint relativo correcto
      final Map<String, dynamic> jsonResponse =
          await _apiService.post('Users/AuthenticateUser', loginData);

      final auth = AuthResponse.fromJson(jsonResponse);

      // ✅ guarda token solo si result = true
      if (auth.result && auth.token != null && auth.token!.isNotEmpty) {
        _apiService.setBearerToken(auth.token!);
      }

      return auth;
    } catch (e) {
      if (kDebugMode) {
        print('Error en LoginController: $e');
      }
      return null;
    }
  }
}
