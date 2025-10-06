import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/theme/appcolor.dart';
import '../model/costumer_model.dart';

class CustomerDetailView extends StatelessWidget {
  final Customer customer;

  const CustomerDetailView({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = customer.estado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Cliente'),
        centerTitle: true,
        backgroundColor: AppColors.oxfordBlue, 
      ),
      backgroundColor: AppColors.lavender, 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300], 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person, size: 70, color: Colors.white),
            ),
            const SizedBox(height: 20),

            Text(
              '${customer.nombre} ${customer.apellido}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF192338), 
              ),
            ),
            const SizedBox(height: 10),

           
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withOpacity(0.2) 
                    : Colors.red.withOpacity(0.2),   
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? Colors.green : Colors.red,
                  width: 1.5,
                ),
              ),
              child: Text(
                isActive ? 'Activo' : 'Inactivo',
                style: TextStyle(
                  color: isActive ? Colors.green[800] : Colors.red[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),

            
            _buildInfoTile(Icons.phone, 'Teléfono', customer.telefono),
            _buildInfoTile(Icons.location_on, 'Dirección', customer.direccion),
            _buildInfoTile(Icons.badge, 'ID Cliente', customer.idCliente.toString()),
            _buildInfoTile(Icons.work, 'ID Empleado', customer.idEmpleados.toString()),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF192338), // 🎨 Color principal del botón
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              label: const Text(
                'Volver',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF192338).withOpacity(0.1), // 🎨 Color icono fondo
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: const Color(0xFF192338)), // 🎨 Color del ícono
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF192338), // 🎨 Texto principal
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
