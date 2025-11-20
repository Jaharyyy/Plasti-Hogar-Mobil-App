import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/view/venta_view.dart';
import '../theme/appcolor.dart';
import 'costumer_view.dart';
import 'ventas_chart.dart';
import 'historial_ventas.dart';

class InicioView extends StatelessWidget {
  final dynamic authResponse;
  const InicioView({super.key, required this.authResponse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        title: const Text(
          'Menú Principal',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.oxfordBlue,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),

            _buildSection(
              title: "📋 Registro",
              items: [
                _menuItem(
                  context,
                  icon: Icons.people,
                  label: "Clientes",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomerView(authResponse: null)),
                    );
                  },
                ),
                _menuItem(
                  context,
                  icon: Icons.store_mall_directory,
                  label: "Proveedores",
                  onTap: () {}, 
                ),
                _menuItem(
                  context,
                  icon: Icons.person_add_alt_1,
                  label: "Usuarios",
                  onTap: () {},
                ),
                _menuItem(
                  context,
                  icon: Icons.badge,
                  label: "Empleados",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildSection(
              title: "💼 Gestión de operaciones",
              items: [
                _menuItem(context,
                    icon: Icons.shopping_cart, label: "Historial de ventas", onTap: () {
                      Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>   const SalesHistoryView ()),

              );
                    }),
                _menuItem(context,
                    icon: Icons.point_of_sale, label: "Historial de compras", onTap: () {}),
                _menuItem(context,
                    icon: Icons.inventory_2, label: "Inventario", onTap: () {}),
                _menuItem(context,
                    icon: Icons.inventory_2, label: "Chart", onTap: () {
                       Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>   const VentasChartView ()),);
                    }),
              ],
            ),

            const SizedBox(height: 12),

            _buildSection(
              title: "📦 Catálogo y transacciones",
              items: [
                _menuItem(context,
                    icon: Icons.category, label: "Catálogo de productos", onTap: () {}),
                _menuItem(context,
                    icon: Icons.swap_horiz, label: "Transacciones de ventas", 
                    onTap: () {
                      Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>   const SaleTransactionView ()),);
                    }),
                _menuItem(context,
                    icon: Icons.swap_vert, label: "Transacciones de compras", onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==== Widgets auxiliares ====

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        collapsedIconColor: AppColors.spaceCadet,
        iconColor: AppColors.oxfordBlue,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF192338),
            fontSize: 18,
          ),
        ),
        children: items,
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.spaceCadet),
      title: Text(label,
          style: const TextStyle(fontSize: 16, color: Colors.black87)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
