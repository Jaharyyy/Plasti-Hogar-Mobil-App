class SaleDetail {
  final int idProductos;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double lineaTotal;

  SaleDetail({
    required this.idProductos,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.lineaTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id_Productos': idProductos,
      'Nombre_Producto': nombreProducto,
      'Cantidad': cantidad,
      'Precio_Unitario': precioUnitario,
      'Linea_Total': lineaTotal,
    };
  }

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      idProductos: json['Id_Productos'] ?? 0,
      nombreProducto: json['Nombre_Producto'] ?? '',
      cantidad: json['Cantidad'] ?? 0,
      precioUnitario: (json['Precio_Unitario'] ?? 0).toDouble(),
      lineaTotal: (json['Linea_Total'] ?? 0).toDouble(),
    );
  }
}
