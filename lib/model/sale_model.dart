// lib/model/sale_model.dart
class CreateSaleDTO {
  final int idCliente;
  final String fechaVenta;
  final List<CreateSaleDetailDTO> detalleVenta;

  CreateSaleDTO({
    required this.idCliente,
    required this.fechaVenta,
    required this.detalleVenta,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id_Cliente': idCliente,
      'Fecha_venta': fechaVenta,
      'Detalle_Venta': detalleVenta.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateSaleDetailDTO {
  final int idProductos;
  final int cantidad;

  CreateSaleDetailDTO({
    required this.idProductos,
    required this.cantidad,
  });

  Map<String, dynamic> toJson() {
    return {
      'Id_Productos': idProductos,
      'Cantidad': cantidad,
    };
  }
}

class SaleResponseDTO {
  final bool result;
  final List<String>? message;
  final int? statusCode;

  SaleResponseDTO({
    required this.result,
    this.message,
    this.statusCode,
  });

  factory SaleResponseDTO.fromJson(Map<String, dynamic> json) {
    return SaleResponseDTO(
      result: json['result'] ?? false,
      message: (json['message'] != null)
          ? List<String>.from(json['message'])
          : null,
      statusCode: json['statusCode'],
    );
  }
}
