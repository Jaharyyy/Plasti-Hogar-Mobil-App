import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/venta_chart.dart';
import '../services/api_services.dart';

class VentaChartController {
  final ApiServices _api = ApiServices();
  static const String _baseUrl = "http://localhost:5059/api/Sales/Obtener_Ventas";

  Future<List<VentaChart>> obtenerVentas() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _api.buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((e) => VentaChart.fromJson(e)).toList();
      } else {
        throw Exception('⚠️ Error al obtener ventas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('❌ Error al conectar con API: $e');
    }
  }
}
