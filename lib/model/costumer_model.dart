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

  // === Getters ===
  int get idCliente => getField('Id_Cliente') ?? 0;
  int get idEmpleados => getField('Id_Empleados') ?? 0;
  String get nombre => getField('Nombre') ?? '';
  String get apellido => getField('Apellido') ?? '';
  String get telefono => getField('Telefono') ?? '';
  String get direccion => getField('Direccion') ?? '';
  bool get estado => getField('Estado') ?? false;
  
  String get nombreCompleto => '$nombre $apellido';

  // === JSON ===
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

  // ✅ Acepta claves en mayúsculas o minúsculas
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
  idCliente: json['Id_Cliente'] ?? json['id_Cliente'] ?? 0,
  idEmpleados: json['Id_Empleados'] ?? json['id_Empleados'] ?? 0,
  nombre: json['Nombre'] ?? json['nombre'] ?? '',
  apellido: json['Apellido'] ?? json['apellido'] ?? '',
  telefono: json['Telefono'] ?? json['telefono'] ?? '',
  direccion: json['Direccion'] ?? json['direccion'] ?? '',
  estado: json['Estado'] ?? json['estado'] ?? false,
);

}

