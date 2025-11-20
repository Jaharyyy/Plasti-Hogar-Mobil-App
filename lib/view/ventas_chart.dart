import 'package:flutter/material.dart';
import '../widgets/ventas_chart.dart'; // Contiene VentasPieChart
import '../model/venta_chart.dart';
import '../theme/appcolor.dart';
import '../widgets/sidebar.dart';
import '../controller/venta_chart_controller.dart';

class VentasChartView extends StatefulWidget {
  const VentasChartView({super.key});

  @override
  State<VentasChartView> createState() => _VentasChartViewState();
}

class _VentasChartViewState extends State<VentasChartView> {
  final VentaChartController _controller = VentaChartController();
  List<VentaChart> ventas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final data = await _controller.obtenerVentas();
    
    // --- CAMBIOS CRUCIALES: AGRUPACIÓN Y SUMA DE DATOS ---
    final Map<String, double> groupedVentas = {};

    for (var venta in data) {
      // Usamos el nombre del producto como clave para agrupar
      final nombre = venta.producto;
      // Sumamos el precio (que representa el total vendido para el gráfico)
      final precioActual = groupedVentas[nombre] ?? 0.0;
      groupedVentas[nombre] = precioActual + venta.precio;
    }

    // Convertimos el Map agrupado de nuevo a una lista de VentaChart
    final List<VentaChart> aggregatedVentas = groupedVentas.entries.map((entry) {
      return VentaChart(
        id: 0,
        fecha: DateTime.now(), // Fecha no es relevante aquí
        producto: entry.key,
        // Usamos la suma total como el valor a graficar
        precio: entry.value, 
        // Nota: Otros campos como idVenta y idUsuario pueden quedar como 0 o nulos aquí 
        // ya que solo necesitamos el nombre y el total para el PieChart.
        
      );
    }).toList();
    // --------------------------------------------------------

    setState(() {
      // Ordenar por valor (precio) descendente para mejor visualización
      ventas = aggregatedVentas..sort((a, b) => b.precio.compareTo(a.precio)); 
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender, 
      appBar: AppBar(
        backgroundColor: AppColors.oxfordBlue,
        title: const Text("Gráfico de Pastel de Ventas", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(authResponse: null),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.oxfordBlue))
          : SingleChildScrollView( 
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.white, 
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Distribución de Ventas por Producto",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.oxfordBlue,
                        ),
                      ),
                      const Divider(color: Colors.black26),
                      SizedBox( 
                        height: 450, // Altura adecuada para el gráfico y el indicador
                        child: VentasPieChart(ventas: ventas), 
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}