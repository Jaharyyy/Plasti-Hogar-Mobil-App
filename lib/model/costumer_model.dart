import 'domain_model.dart';
import 'domain_model.dart';

class Customer extends DomainModel {
  Customer({
    int? idCliente,
    int? idEmpleados,
    String? nombre,
    String? apellido,
    String? telefono,
    String? direccion,
    bool? estado,
  }) : super(domain: 'Customers') {
    setField('Id_Cliente', idCliente ?? 0);
    setField('Id_Empleados', idEmpleados ?? 0);
    setField('Nombre', nombre ?? '');
    setField('Apellido', apellido ?? '');
    setField('Telefono', telefono ?? '');
    setField('Direccion', direccion ?? '');
    setField('Estado', estado ?? false);
  }

  // === Getters seguros ===
  int get idCliente => getField('Id_Cliente') ?? 0;
  int get idEmpleados => getField('Id_Empleados') ?? 0;
  String get nombre => getField('Nombre') ?? '';
  String get apellido => getField('Apellido') ?? '';
  String get telefono => getField('Telefono') ?? '';
  String get direccion => getField('Direccion') ?? '';
  bool get estado => getField('Estado') ?? false;

  // === Serialización a JSON ===
  Map<String, dynamic> toJson() {
    return {
      'Id_Cliente': idCliente,
      'Id_Empleados': idEmpleados,
      'Nombre': nombre,
      'Apellido': apellido,
      'Telefono': telefono,
      'Direccion': direccion,
      'Estado': estado,
    };
  }

  // === Fábrica desde JSON del backend ===
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        idCliente: json['Id_Cliente'] ?? 0,
        idEmpleados: json['Id_Empleados'] ?? 0,
        nombre: json['Nombre'] ?? '',
        apellido: json['Apellido'] ?? '',
        telefono: json['Telefono'] ?? '',
        direccion: json['Direccion'] ?? '',
        estado: json['Estado'] ?? false,
      );
}
