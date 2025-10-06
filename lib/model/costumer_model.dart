import 'domain_model.dart';
class Customer extends DomainModel {
  Customer({
    required int idCliente,
    required int idEmpleados,
    required String nombre,
    required String apellido,
    required String telefono,
    required String direccion,
    required bool estado,
  }) : super(domain: 'Customers') {
    setField('Id_Cliente', idCliente);
    setField('Id_Empleados', idEmpleados);
    setField('Nombre', nombre);
    setField('Apellido', apellido);
    setField('Telefono', telefono);
    setField('Direccion', direccion);
    setField('Estado', estado);
  }

    // === Getters ===
  int get idCliente => getField('Id_Cliente');
  int get idEmpleados => getField('Id_Empleados');
  String get nombre => getField('Nombre');
  String get apellido => getField('Apellido');
  String get telefono => getField('Telefono');
  String get direccion => getField('Direccion');
  bool get estado => getField('Estado');


Map<String, dynamic> toJson() {
  return {
    'Id_Cliente': getField('Id_Cliente'),
    'Id_Empleados': getField('Id_Empleados'),
    'Nombre': getField('Nombre'),
    'Apellido': getField('Apellido'),
    'Telefono': getField('Telefono'),
    'Direccion': getField('Direccion'),
    'Estado': getField('Estado'),
  };
}


  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        idCliente: json['Id_Cliente'],
        idEmpleados: json['Id_Empleados'],
        nombre: json['Nombre'],
        apellido: json['Apellido'],
        telefono: json['Telefono'],
        direccion: json['Direccion'],
        estado: json['Estado'],
      );
}
