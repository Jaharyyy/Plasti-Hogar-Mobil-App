import 'sale_detail.dart';

class Sale {
  final int? idVenta;
  final int idCliente;
  final DateTime fechaVenta;
  final List<SaleDetail> detalleVenta;

  Sale({
    this.idVenta,
    required this.idCliente,
    required this.fechaVenta,
    required this.detalleVenta,
  });

  double get total {
    return detalleVenta.fold(0.0, (sum, detail) => sum + detail.lineaTotal);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id_Cliente': idCliente,
      'Fecha_Venta': fechaVenta.toIso8601String(),
      'Detalle_Venta': detalleVenta.map((e) => e.toJson()).toList(),
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    var detallesJson = json['Detalle_Venta'] as List? ?? [];
    List<SaleDetail> detalles =
        detallesJson.map((e) => SaleDetail.fromJson(e)).toList();

    return Sale(
      idVenta: json['Id_Venta'],
      idCliente: json['Id_Cliente'] ?? 0,
      fechaVenta: DateTime.parse(json['Fecha_Venta']),
      detalleVenta: detalles,
    );
  }
}