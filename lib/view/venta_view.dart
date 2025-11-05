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
  double totalVenta = detalles.fold(0.0, (sum, item) => sum + item.lineaTotal);

  return Scaffold(
    backgroundColor: AppColors.lavender,
    appBar: AppBar(
      backgroundColor: AppColors.oxfordBlue,
      title: const Text("🧾 Registrar Venta"),
      centerTitle: true,
    ),
    drawer: AppDrawer(authResponse: null),

    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
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
                                  child: const Icon(Icons.shopping_bag_outlined,
                                      color: Colors.blue),
                                ),
                                title: Text(
                                  item.nombreProducto,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 228, 226, 226)                
                                    ),
                                ),
                                subtitle: Text(
                                  "Cantidad: ${item.cantidad} × C\$${item.precioUnitario.toStringAsFixed(2)}",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "C\$${item.lineaTotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.redAccent),
                                      tooltip: "Eliminar producto",
                                      onPressed: () {
                                        setState(() {
                                          detalles.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "🗑️ ${item.nombreProducto} eliminado",
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "C\$${totalVenta.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

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