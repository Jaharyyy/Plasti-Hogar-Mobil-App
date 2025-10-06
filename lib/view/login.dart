import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/controller/login_controller.dart'; 
import 'package:plastihogar_flutter/model/auth_response.dart'; 
import '../view/inicio_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

const Color _primaryColor = Color.fromARGB(255, 43, 94, 123);
const Color _secondaryColor = Color(0xFF5992B2);
const Color _backgroundColor = Color.fromARGB(255, 255, 255, 255);

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
        _passwordController.text
      );
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      if (result != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => InicioScreen(authResponse: result)),
          (Route<dynamic> route) => false, 
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Error: Credenciales incorrectas o Fallo de conexión.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
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
                
                  Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _secondaryColor.withAlpha(25), 
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

                  const Text(
                    'Estimado Usuario',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'SEA BIENVENIDO OTRA VEZ', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryColor),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'Asegúrese de escribir su nombre, apellido y contraseña correctamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 35),

                  TextFormField(
                    controller: _usernameController, 
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Nombres y Apellidos',
                      labelStyle: TextStyle(color:  Colors.white70),
                      filled: true,
                      fillColor: _primaryColor.withAlpha(230), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15), 
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.white),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Ingrese su nombre y apellido' : null,
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: _primaryColor.withAlpha(230), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Ingrese su contraseña' : null,
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _performLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: _primaryColor, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), 
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24, height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'INICIAR SESION', 
                                style: TextStyle(
                                  fontSize: 18, 
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.check_box_outlined, color: Colors.white, size: 24),
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