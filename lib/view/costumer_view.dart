import 'package:flutter/material.dart';
import 'package:plastihogar_flutter/theme/appcolor.dart';
import '../controller/costumer_controller.dart';
import '../model/costumer_model.dart';
import 'detallecostumer_view.dart';
import 'addcustomer_view.dart';
import '../widgets/sidebar.dart';

class CustomerView extends StatefulWidget {
  final dynamic authResponse;

  const CustomerView({super.key, required this.authResponse});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}


class _CustomerViewState extends State<CustomerView> {
  final CustomerController _controller = CustomerController();
  bool _verActivos = true; // Alternar entre activos e inactivos

  late Future<List<Customer>> _futureCustomers;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  void _cargarClientes() {
    setState(() {
      _futureCustomers = _verActivos
          ? _controller.getActiveCustomers()
          : _controller.getInactiveCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height; // ✅ evita LateInitError

    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        title: Text(
          _verActivos ? 'Clientes Activos' : 'Clientes Inactivos',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
            centerTitle: true,
        backgroundColor: AppColors.oxfordBlue,
        elevation: 4,

        actions: [
          IconButton(
  icon: const Icon(Icons.add_circle_outline),
  tooltip: 'Agregar nuevo cliente',
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddCustomerView()),
    );

    if (result == true) {
      _cargarClientes(); // 🔄 actualiza la lista al volver
    }
  },
),

          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargarClientes,
          ),
        ],
      ),
      
      drawer: AppDrawer(authResponse: widget.authResponse),

      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildToggleButtons(),
          Expanded(
            child: FutureBuilder<List<Customer>>(
              future: _futureCustomers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay clientes disponibles.'));
                }

                final customers = snapshot.data!;
                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _buildCustomerCard(customer);
                  },
                );
              },
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // ✅ margen final proporcional
        ],
      ),
    );
  }

  /// 🔘 Botones para alternar entre clientes activos e inactivos
  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Activos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _verActivos
                  ? const Color(0xFF4CAF50)
                  : Colors.grey[400],
            ),
            onPressed: () {
              if (!_verActivos) {
                setState(() {
                  _verActivos = true;
                  _cargarClientes();
                });
              }
            },
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.cancel),
            label: const Text('Inactivos'),
            style: ElevatedButton.styleFrom(
              backgroundColor: !_verActivos
                  ? const Color(0xFFE53935)
                  : Colors.grey[400],
            ),
            onPressed: () {
              if (_verActivos) {
                setState(() {
                  _verActivos = false;
                  _cargarClientes();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /// 🧾 Tarjeta individual para cada cliente
  Widget _buildCustomerCard(Customer customer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
      context,
        MaterialPageRoute(
    builder: (_) => CustomerDetailView(customer: customer),
      ),
          ).then((_) {
  // 🟢 Esto se ejecuta al volver del detalle
      _cargarClientes(); // 🔄 Recarga la lista desde la API
      });

      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 🔹 Avatar circular
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF31487A), // 🎨 tono azul intermedio de tu paleta
                ),
                child: const Icon(Icons.person, size: 36, color: Colors.white),
              ),
              const SizedBox(width: 16),
              // 🔹 Información del cliente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${customer.nombre} ${customer.apellido}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF192338),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Teléfono: ${customer.telefono}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.spaceCadet,
                      ),
                    ),
                    Text(
                      'Dirección: ${customer.direccion}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
