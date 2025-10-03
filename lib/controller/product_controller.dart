import 'package:plastihogar_flutter/services/api_services.dart';
import '../model/product_model.dart';
import 'package:flutter/material.dart';

class ProductController {
late Product _product;
final ApiServices _api = ApiServices();
//METODOS PARA REALIZAR ACCIONES POSTERIORES A LA EJECUCION DEL METODO HTTP
VoidCallback onUpdate = () {};
VoidCallback onCreate = () {};
VoidCallback onDelete = () {};
ProductController(int id, String name, int quantity, double price, int categoryId, bool status) {
_product = Product(id: id, nombre: name, cantidad: quantity, precio: price, categoriaId: categoryId, estado: status);
}
// Getters
Product get product => _product;
String get description => _product.nombre;
Future<void> updateProduct(int id, String nombre, int cantidad, double precio, int categoriaId, bool estado) async {
_product = Product(id: id, nombre: nombre, cantidad: cantidad, precio: precio, categoriaId: categoriaId, estado: estado);
try {
await _api.put(model: _product);
onUpdate();
} catch (e) {
throw Exception('Error al actualizar: $e');
}
}
Future<void> createUser(int id, String nombre, int cantidad, double precio, int categoriaId, bool estado) async {
_product = Product(id: id, nombre: nombre, cantidad: cantidad, precio: precio, categoriaId: categoriaId, estado: estado );
try {
final newProduct = await _api.post<Product>(model: _product);
_product = newProduct;
onCreate();
} catch (e) {
throw Exception('Error al crear: $e');
}

}
Future<void> deleteProduct() async {
try {
await _api.delete(model: _product);
onDelete();
} catch (e) {
throw Exception('Error al eliminar: $e');
}
}
}