import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../model/venta_chart.dart'; 
import '../theme/appcolor.dart'; 

class VentasPieChart extends StatefulWidget {
  final List<VentaChart> ventas;
  
  const VentasPieChart({super.key, required this.ventas});

  @override
  State<VentasPieChart> createState() => _VentasPieChartState();
}

class _VentasPieChartState extends State<VentasPieChart> {
  int touchedIndex = -1; 
  
  // Colores para las secciones del pastel (puedes añadir más si tienes muchos productos)
  final List<Color> pieColors = [
    AppColors.oxfordBlue,
    Colors.deepOrange,
    Colors.green[700]!, // Usamos un verde oscuro para contraste
    Colors.purple[700]!,
    Colors.teal[700]!,
    Colors.pink[700]!,
    Colors.cyan[700]!,
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.ventas.isEmpty) {
      return const Center(child: Text("No hay datos disponibles para el gráfico de pastel", style: TextStyle(color: Colors.grey)));
    }

    final double totalVentas = widget.ventas.fold(0.0, (sum, item) => sum + item.precio);

    return Column(
      children: [
        Expanded(
          // 1. Gráfico de Pastel
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2, 
              centerSpaceRadius: 40, 
              sections: _buildSections(totalVentas),
            ),
          ),
        ),
        
        // 2. Indicador / Leyenda de la Sección Tocada
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: _buildIndicator(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(double totalVentas) {
    return widget.ventas.asMap().entries.map((entry) {
      final index = entry.key;
      final venta = entry.value;
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 70 : 60; // Incrementamos el radio al tocar
      final Color color = pieColors[index % pieColors.length];
      final double percentage = (venta.precio / totalVentas) * 100;
      
      return PieChartSectionData(
        color: color,
        value: venta.precio, 
        // Mostramos solo el porcentaje grande en la sección tocada
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '', 
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: isTouched ? [const Shadow(color: Colors.black, blurRadius: 2)] : null,
        ),
        titlePositionPercentageOffset: 0.6,
      );
    }).toList();
  }
  
  // Widget de indicador que muestra la información
  Widget _buildIndicator() {
    if (touchedIndex != -1) {
      final venta = widget.ventas[touchedIndex];
      final color = pieColors[touchedIndex % pieColors.length];
      final double totalVentas = widget.ventas.fold(0.0, (sum, item) => sum + item.precio);
      final double percentage = (venta.precio / totalVentas) * 100;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  venta.producto, // Nombre del Producto
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.oxfordBlue
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Cantidad de Ventas: C\$${venta.precio.toStringAsFixed(2)}', // Cantidad
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Text(
              'Contribución: ${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'Toque una sección para ver los detalles.',
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }
  }
}