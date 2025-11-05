import 'package:flutter/material.dart';
import '../theme/appcolor.dart';
import '../view/costumer_view.dart';
import '../view/principal_view.dart';
import '../view/venta_view.dart';

class AppDrawer extends StatelessWidget {
  final dynamic authResponse;

  const AppDrawer({super.key, required this.authResponse});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.lavender,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ==== ENCABEZADO ====
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.oxfordBlue,
              ),
              accountName: Text(
                authResponse != null ? authResponse['nombreUsuario'] ?? 'Usuario' : 'Usuario',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                authResponse != null ? authResponse['rol'] ?? 'Rol' : 'Administrador',
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Color(0xFF192338)),
              ),
            ),

            // ==== 📋 REGISTRO ====
            _buildSectionHeader("📋 Registro"),
            _menuItem(context, Icons.people, "Clientes", () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => CustomerView(authResponse: authResponse)),
              );
            }),
            _menuItem(context, Icons.store_mall_directory, "Proveedores", () {}),
            _menuItem(context, Icons.person_add_alt_1, "Usuarios", () {}),
            _menuItem(context, Icons.badge, "Empleados", () {}),

            const Divider(),

            // ==== 💼 GESTIÓN ====
            _buildSectionHeader("💼 Gestión de operaciones"),
            _menuItem(context, Icons.shopping_cart, "Historial de ventas", () {
              
            }),
            _menuItem(context, Icons.point_of_sale, "Historial de compras", () {}),
            _menuItem(context, Icons.inventory_2, "Inventario", () {}),

            const Divider(),

            // ==== 📦 CATÁLOGO ====
            _buildSectionHeader("📦 Catálogo y transacciones"),
            _menuItem(context, Icons.category, "Catálogo de productos", () {}),
            _menuItem(context, Icons.swap_horiz, "Transacciones de ventas", () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>   const SaleTransactionView ()),

                );
            }),
            _menuItem(context, Icons.swap_vert, "Transacciones de compras", () {}),

            const Divider(),

            // ==== PERFIL / SALIR ====
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black54),
              title: const Text('Volver al menú principal'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) =>   const InicioView (authResponse: null)),

                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ==== AUXILIARES ====

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.spaceCadet),
      title: Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      onTap: onTap,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF192338),
          fontSize: 17,
        ),
      ),
    );
  }
}
