import 'package:flutter/material.dart';
import '../controller/venta_chart_controller.dart';
import '../model/venta_chart.dart';
import '../widgets/ventas_chart.dart';
import '../theme/appcolor.dart';
import '../widgets/sidebar.dart';

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
    try {
      final data = await _controller.obtenerVentas();
      setState(() {
        ventas = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar ventas: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      drawer: AppDrawer(authResponse: null),
      appBar: AppBar(
        title: const Text("📊 Gráfico de Ventas"),
        backgroundColor: AppColors.oxfordBlue,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ventas.isEmpty
              ? const Center(child: Text("No hay datos disponibles"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: VentasBarChart(ventas: ventas),
                ),
    );
  }
}
