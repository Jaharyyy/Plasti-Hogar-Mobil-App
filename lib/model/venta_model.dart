class Sale {
  final int idVenta;
  final int idCliente;
  final String nombreCliente;
  final DateTime fechaVenta;
  final List<SaleDetail> detalleVenta;

  Sale({
    required this.idVenta,
    required this.idCliente,
    required this.nombreCliente,
    required this.fechaVenta,
    required this.detalleVenta,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    var detalles = <SaleDetail>[];
    if (json['detalle_Venta'] != null) {
      detalles = List<SaleDetail>.from(
        json['detalle_Venta'].map((x) => SaleDetail.fromJson(x)),
      );
    }

    return Sale(
      idVenta: json['id_Venta'] ?? 0,
      idCliente: json['id_Cliente'] ?? 0,
      nombreCliente: json['nombre_Cliente'] ?? '',
      fechaVenta: DateTime.parse(json['fecha_venta']),
      detalleVenta: detalles,
    );
  }
}

class SaleDetail {
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double lineaTotal;

  SaleDetail({
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.lineaTotal,
  });

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      nombreProducto: json['nombre_Producto'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precioUnitario:
          (json['precio_Unitario'] is int) ? (json['precio_Unitario'] as int).toDouble() : json['precio_Unitario'] ?? 0.0,
      lineaTotal:
          (json['linea_Total'] is int) ? (json['linea_Total'] as int).toDouble() : json['linea_Total'] ?? 0.0,
    );
  }
}
