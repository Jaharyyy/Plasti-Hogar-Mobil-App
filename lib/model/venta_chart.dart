class VentaChart {
  final int id;
  final String producto;
  final double precio;
  final DateTime fecha;

  VentaChart({
    required this.id,
    required this.producto,
    required this.precio,
    required this.fecha,
  });

  factory VentaChart.fromJson(Map<String, dynamic> json) {
  final detalles = json['detalle_Venta'] as List<dynamic>? ?? [];
  final primerDetalle = detalles.isNotEmpty ? detalles.first : null;

  return VentaChart(
    id: json['id_Venta'] ?? 0,
    producto: primerDetalle?['nombre_Producto'] ?? 'Sin producto',
    precio: (primerDetalle?['linea_Total'] as num?)?.toDouble() ?? 0.0,
    fecha: DateTime.tryParse(json['fecha_Venta'] ?? '') ?? DateTime.now(),
  );
}

}
