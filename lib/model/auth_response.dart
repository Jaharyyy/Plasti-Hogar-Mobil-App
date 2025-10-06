class AuthResponse {
  
  final String token;
  
  // Datos del Usuario - Corregidas a lowerCamelCase
  final String nombreUsuario;
  final int idUsuario;
  
  // Constructor principal
  AuthResponse({
    required this.token,
    required this.nombreUsuario,
    required this.idUsuario,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    
    // Mapeamos 'Token' (con mayúscula)
    final token = (json['Token'] as String?) ?? ''; 

    // Mapeamos 'Usuario' (con mayúscula)
    final usuarioData = json['Usuario'] as Map<String, dynamic>?;

    if (usuarioData == null) {
      throw const FormatException("Error de mapeo: Falta la clave 'Usuario' en la respuesta.");
    }

    // Mapeamos las claves tal como vienen del servidor
    final idUsuario = usuarioData['Id'] as int;
    final nombreUsuario = usuarioData['Nombre_Usuario'] as String;
    
    return AuthResponse(
      token: token,
      idUsuario: idUsuario,
      nombreUsuario: nombreUsuario,
    );
  }
}
