
import 'domain_model.dart';


class Product extends DomainModel {
Product({required int id, required String nombre, required int cantidad, required double precio, required int categoriaId, required bool estado})
: super(domain: 'ProductModel') {
  setField('id', id);
  setField('nombre', nombre);
  setField('cantidad', cantidad);
  setField('precio', precio);
  setField('categoriaId', categoriaId);
  setField('estado', estado);
}
int get id => getField('id');
String get nombre => getField('nombre');
}


