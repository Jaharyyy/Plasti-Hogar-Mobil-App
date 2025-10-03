import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/model/product_model.dart';
import 'view/loginprueba.dart';

import 'controller/product_controller.dart';
import 'repository/product_repository.dart';
import 'model/type_registry.dart';
import 'view/product_view.dart';


// Llama esto en main()
void registerModels() {
TypeRegistry.register<Product>('', (json) {
return Product(
id: json['id'],
nombre: json['name'],
cantidad: json['quantity'],
precio: (json['price'] as num).toDouble(),
categoriaId: json['categoryId'],
estado: json['status'], 
);
});
}

void  main() {
  runApp(const MyApp());
  testLogin();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('prueba')),
        body: const Center(
          child: Text("revisa la consola"),
        ),
      )
    );
  }
}


