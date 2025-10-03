import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_services.dart';

final api = ApiServices();

Future<void> testLogin() async {
  try {
    final response = await http.post(
      Uri.parse("http://localhost:5059/api/Users/AuthenticateUser"), // 👈 tu URL
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "Nombre_Usuario": "Jahary",   // 👈 cámbialo por usuario real
        "PasswordHash": "jahary2025"             // 👈 cámbialo por clave real
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ⚠️ tu backend seguramente devuelve algo como { "token": "xxxx" }
      final token = data["token"] ?? data["accessToken"]; 

      print("✅ Login correcto, token: $token");

      // Guardamos el token en ApiServices para futuras llamadas
      api.setBearerToken(token);
    } else {
      print("❌ Login falló: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("⚠️ Error en login: $e");
  }
}
