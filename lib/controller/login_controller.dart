import 'package:plastihogar_flutter/model/auth_response.dart'; 
import 'package:plastihogar_flutter/services/api_services.dart'; 
import 'package:flutter/foundation.dart'; 

class LoginController {
  
  final ApiServices _apiService = ApiServices();

  // ignore: non_constant_identifier_names
  Future<AuthResponse?> performLogin(String nombreUsuario, String Password) async {
 
    final Map<String, dynamic> loginData = {
      'nombre_Usuario': nombreUsuario,
      'passwordHash': Password,
    };
    
    try {
      final Map<String, dynamic> jsonResponse = await _apiService.post(
        'http://localhost:5059/api/Users/AuthenticateUser', 
        loginData,
      );
      
      return AuthResponse.fromJson(jsonResponse);
      
    } catch (e) {
 
      if (kDebugMode) {
        print('Error en LoginController: $e');
      }
      return null;
    }
  }
}