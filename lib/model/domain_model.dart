import 'package:flutter/material.dart';
/// Clase base abstracta que permite serialización automática
/// sin necesidad de que los hijos definan toJson/fromJson.
abstract class DomainModel {
String domain;
// Almacenamos los campos del modelo en un mapa interno
final Map<String, dynamic> _data = {};
DomainModel({required this.domain});
/// Devuelve el endpoint del backend
String getDomain() => '$domain.php';
/// Método protegido para definir propiedades (se llama en el constructor)
@protected
void setField(String key, dynamic value) {
_data[key] = value;
}
/// Acceso tipo "propiedad"
dynamic getField(String key) => _data[key];
/// Serializa todo el objeto automáticamente
Map<String, dynamic> toJson() => Map.from(_data);
/// Permite clonar o actualizar el modelo (inmutabilidad opcional)
Map<String, dynamic> toMutableMap() => Map.from(_data);
}

