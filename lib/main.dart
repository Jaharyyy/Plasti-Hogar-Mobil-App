import 'package:flutter/material.dart'; 
import 'view/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 🔹 quita el banner rojo
      title: 'Catálogo de Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF192338), // 🎨 color principal
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginScreen(), // 👈 esta es la pantalla que se carga primero
    );
  }
}
