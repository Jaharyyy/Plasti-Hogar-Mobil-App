class Product {
  final int idProductos;
  final String nombreProducto;
  final int cantidadExistente;
  final double precio;
  final int categoriaId;
  final bool estado;

  Product({
    required this.idProductos,
    required this.nombreProducto,
    required this.cantidadExistente,
    required this.precio,
    required this.categoriaId,
    required this.estado,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProductos: json['id_Productos'],
      nombreProducto: json['nombre_Producto'],
      cantidadExistente: json['cantidad_Existente'],
      precio: (json['precio'] as num).toDouble(),
      categoriaId: json['categoria_Id'],
      estado: json['estado'],
    );
  }
}



