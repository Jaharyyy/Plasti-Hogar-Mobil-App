import 'package:flutter/material.dart'; 
import 'package:sizer/sizer.dart';
import 'view/inicio_view.dart';

void main() {
  runApp(const MyApp(authResponse: dynamic,));
}

class MyApp extends StatelessWidget {
  final dynamic authResponse;
  const MyApp ({super.key, required this.authResponse});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            debugShowCheckedModeBanner: false, 
          title: 'Catálogo de Clientes',
          theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF192338), 
            foregroundColor: Colors.white,
        ),
      ),
      home: const InicioScreen(authResponse: null,), 
    );
  }
  );
}
}