class AuthResponse {
  final bool result;
  final String? token;
  final String? errors;

  AuthResponse({
    required this.result,
    this.token,
    this.errors,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      result: json['result'] ?? false,
      token: json['token'],
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'token': token,
        'errors': errors,
      };
}
