import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../model/venta_chart.dart';
import '../theme/appcolor.dart';

class VentasBarChart extends StatelessWidget {
  final List<VentaChart> ventas;

  const VentasBarChart({super.key, required this.ventas});

  @override
  Widget build(BuildContext context) {
    final maxY = ventas.map((v) => v.precio).reduce((a, b) => a > b ? a : b) * 1.2;

    return Card(
      elevation: 4,
      color: AppColors.lavender,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              // EJE IZQUIERDO (valores)
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => Text(
                    "C\$${value ~/ 1000}K",
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
              ),

              // EJE INFERIOR (productos)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (ventas.length / 6).ceilToDouble(), // muestra aprox. 6 etiquetas
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= ventas.length) return const SizedBox();
                    final nombre = ventas[index].producto;

                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.rotate(
                        angle: -0.5, // rota texto para que no se encime
                        child: Text(
                          nombre.length > 8 ? "${nombre.substring(0, 8)}…" : nombre,
                          style: const TextStyle(fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // DATOS DE LAS BARRAS
            barGroups: ventas.asMap().entries.map((entry) {
              int index = entry.key;
              VentaChart venta = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: venta.precio,
                    color: AppColors.oxfordBlue,
                    width: 14,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              );
            }).toList(),

            maxY: maxY,
          ),
        ),
      ),
    );
  }
}
