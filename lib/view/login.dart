import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/controller/login_controller.dart';
import 'package:plastihogar_flutter/model/auth_response.dart';
import 'package:plastihogar_flutter/view/costumer_view.dart';
import 'inicio_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// 🎨 Colores base (ajústalos según tu paleta)
const Color _primaryColor = Color(0xFF192338); // color principal
const Color _secondaryColor = Color(0xFF5992B2); // acento secundario
const Color _backgroundColor = Color(0xFFFFFFFF); // fondo claro

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginController _loginController = LoginController();
  bool _isLoading = false;

  void _performLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final AuthResponse? result = await _loginController.performLogin(
        _usernameController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (result != null && result.result) {
        // ✅ Login exitoso, ir a InicioScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerView(authResponse: result),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        // ❌ Login fallido
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result?.errors ??
                  '❌ Credenciales incorrectas o error de conexión.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 500 ? 400.0 : screenWidth * 0.85;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: cardWidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Logo circular con iniciales PH
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _secondaryColor.withOpacity(0.1),
                      border: Border.all(color: _secondaryColor, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        'PH',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: _secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Textos de bienvenida
                  const Text(
                    'Estimado Usuario',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'SEA BIENVENIDO OTRA VEZ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Asegúrese de escribir su usuario y contraseña correctamente.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Campo Usuario
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: _primaryColor.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Ingrese su nombre de usuario'
                            : null,
                  ),
                  const SizedBox(height: 20),

                  // Campo Contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: _primaryColor.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Ingrese su contraseña'
                            : null,
                  ),
                  const SizedBox(height: 40),

                  // Botón Login
                  ElevatedButton(
                    onPressed: _isLoading ? null : _performLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: _primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'INICIAR SESIÓN',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.login, color: Colors.white, size: 24),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
