import 'package:flutter/material.dart';
import '../controller/sale_controller.dart';
import '../controller/costumer_controller.dart';
import '../controller/producto_controller.dart';
import '../model/sale_model.dart';
import '../model/sale_detail.dart';
import '../model/costumer_model.dart';
import '../model/product_model.dart';
import '../theme/appcolor.dart';
import '../widgets/sidebar.dart';
import 'agregarproducto_modal.dart';

class SaleTransactionView extends StatefulWidget {
  const SaleTransactionView({super.key});

  @override
  State<SaleTransactionView> createState() => _SaleTransactionViewState();
}

class _SaleTransactionViewState extends State<SaleTransactionView> {
  final SalesController _saleController = SalesController();
  final CustomerController _customerController = CustomerController();
  final ProductController _productController = ProductController();

  int? selectedCustomerId;
  List<Customer> customers = [];
  List<Product> products = [];
  List<SaleDetail> detalles = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => isLoading = true);
    try {
      final clientesActivos = await _customerController.getActiveCustomers();
      final productosActivos = await _productController.obtenerProductosActivos();
      setState(() {
        customers = clientesActivos;
        products = productosActivos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar datos: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _abrirModalAgregarProducto() {
  showDialog(
    context: context,
    builder: (context) => AgregarProductoModal(
      onAgregar: (Product producto, int cantidad) {
        final detalle = SaleDetail(
          idProductos: producto.idProductos,
          nombreProducto: producto.nombreProducto,
          cantidad: cantidad,
          precioUnitario: producto.precio,
          lineaTotal: producto.precio * cantidad,
        );

        setState(() {
          detalles.add(detalle);
        });
      },
    ),
  );
}





  Future<void> _guardarVenta() async {
    if (selectedCustomerId == null || detalles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe seleccionar un cliente y al menos un producto")),
      );
      return;
    }

    final nuevaVenta = Sale(
      idCliente: selectedCustomerId!,
      fechaVenta: DateTime.now(),
      detalleVenta: detalles,
    );

    final exito = await _saleController.insertarVenta(nuevaVenta);

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Venta registrada correctamente")),
      );
      setState(() {
        detalles.clear();
        selectedCustomerId = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Error al registrar la venta")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.oxfordBlue,
        title: const Text("🧾 Registrar Venta"),
        centerTitle: true,
      ),
      // 🔹 Sidebar (menú lateral)
      drawer: AppDrawer(authResponse: null),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cliente
                  DropdownButtonFormField<int>(
                    value: selectedCustomerId,
                    decoration: InputDecoration(
                      labelText: "Seleccionar cliente",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: customers.map((c) {
                      return DropdownMenuItem<int>(
                        value: c.idCliente,
                        child: Text('${c.nombre} ${c.apellido}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedCustomerId = value);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Lista de productos agregados
                  Expanded(
                    child: detalles.isEmpty
                        ? const Center(
                            child: Text(
                              "🛒 No hay productos agregados",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: detalles.length,
                            itemBuilder: (context, index) {
                              final item = detalles[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 3,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue[100],
                                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
                                  ),
                                  title: Text(
                                    item.nombreProducto,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF192338)),
                                  ),
                                  subtitle: Text(
                                    "Cantidad: ${item.cantidad} × C\$${item.precioUnitario.toStringAsFixed(2)}",
                                  ),
                                  trailing: Text(
                                    "C\$${item.lineaTotal.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Botones inferiores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _abrirModalAgregarProducto,
                        icon: const Icon(Icons.add),
                        label: const Text("Agregar producto"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.spaceCadet,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _guardarVenta,
                        icon: const Icon(Icons.save),
                        label: const Text("Guardar venta"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
