
import 'domain_model.dart';

class TypeRegistry {
static final Map<String, Function(Map<String, dynamic>)> _constructors = {};
static void register<T extends DomainModel>(
String typeName,
T Function(Map<String, dynamic>) constructor,
)
{

_constructors[typeName] = constructor;
}
static T create<T extends DomainModel>(String typeName, Map<String, dynamic> json) {
final fn = _constructors[typeName];
if (fn == null) throw Exception("Tipo no registrado: $typeName");
return fn(json) as T;
}
}