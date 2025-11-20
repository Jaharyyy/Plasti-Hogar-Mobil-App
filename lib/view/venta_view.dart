import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

import '../controller/sale_controller.dart';
import '../controller/costumer_controller.dart';
import '../controller/producto_controller.dart';
import '../model/sale_model.dart';
import '../model/sale_detail.dart';
import '../model/costumer_model.dart';
import '../model/product_model.dart';
import '../theme/appcolor.dart'; // Asegúrate de que este archivo AppColors tenga los colores que deseas
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

  // Constante del IVA (ejemplo: 15%)
  static const double IVA_RATE = 0.15;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
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
        const SnackBar(content: Text("Venta registrada correctamente")),
      );
      setState(() {
        detalles.clear();
        selectedCustomerId = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al registrar la venta")),
      );
    }
  }

  // Helper para calcular Subtotal, IVA y Total
  Map<String, double> _calcularTotales() {
    double subtotal = detalles.fold(0.0, (sum, item) => sum + item.lineaTotal);
    double iva = subtotal * IVA_RATE;
    double total = subtotal + iva;
    return {'subtotal': subtotal, 'iva': iva, 'total': total};
  }

  @override
  Widget build(BuildContext context) {
    final totales = _calcularTotales();
    final String subtotal = totales['subtotal']!.toStringAsFixed(2);
    final String iva = totales['iva']!.toStringAsFixed(2);
    final String total = totales['total']!.toStringAsFixed(2);
    
    String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Buscamos el nombre del cliente seleccionado para el hint
    final selectedCustomerName = customers
        .firstWhereOrNull((c) => c.idCliente == selectedCustomerId)
        ?.nombreCompleto; // Asumiendo que tienes un getter nombreCompleto

    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.oxfordBlue,
        title: const Text("Registrar Venta", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(authResponse: null),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Encabezado de Venta ---
                  Card(
                    color: AppColors.spaceCadet, 
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Fecha
                          Text(
                            "Fecha: $fechaActual",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Selector de Cliente (Alineado y con texto dinámico)
                          DropdownButtonFormField<int>(
                            value: selectedCustomerId,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            decoration: InputDecoration(
                              labelText: selectedCustomerId == null 
                                  ? "Seleccionar Cliente" // Texto solo cuando no hay cliente
                                  : null,
                              hintText: selectedCustomerName != null 
                                  ? selectedCustomerName 
                                  : null,
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.oxfordBlue, fontSize: 16),
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.oxfordBlue,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: customers.map((c) {
                              return DropdownMenuItem<int>(
                                value: c.idCliente,
                                child: Text('${c.nombre} ${c.apellido}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedCustomerId = value);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Botón para Agregar Producto
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _abrirModalAgregarProducto,
                              icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 24),
                              label: const Text("AGREGAR PRODUCTO", style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              )),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.oxfordBlue,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Detalle de Productos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.oxfordBlue,
                    ),
                  ),
                  const Divider(color: AppColors.oxfordBlue),

                  // Lista de Productos (Tarjeta blanca)
                  Expanded(
                    child: detalles.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay productos agregados",
                              style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: detalles.length,
                            itemBuilder: (context, index) {
                              final item = detalles[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: Colors.white, // Tarjeta blanca
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: Colors.black12)
                                ),
                                elevation: 3,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.oxfordBlue),
                                  title: Text(
                                    item.nombreProducto,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.oxfordBlue, // Texto en color oscuro
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${item.cantidad} unidades × C\$${item.precioUnitario.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "C\$${item.lineaTotal.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          color: Colors.green, 
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red, size: 24),
                                        tooltip: "Eliminar producto",
                                        onPressed: () {
                                          setState(() {
                                            detalles.removeAt(index);
                                          });
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${item.nombreProducto} eliminado",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 16),

                  // --- Cálculo de Subtotal, IVA y Total (Sin tarjeta azul) ---
                  _buildTotalRow("Subtotal:", "C\$$subtotal", Colors.black87, 18.0, FontWeight.normal),
                  _buildTotalRow("IVA (${(IVA_RATE * 100).toStringAsFixed(0)}%):", "C\$$iva", Colors.black87, 18.0, FontWeight.normal),
                  const Divider(color: Colors.black54, thickness: 1.5),
                  _buildTotalRow("TOTAL A PAGAR:", "C\$$total", Colors.red[800]!, 22.0, FontWeight.bold),
                  
                  const SizedBox(height: 16),

                  // Botón de Guardar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _guardarVenta,
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                      label: const Text("FINALIZAR VENTA", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Widget de ayuda para construir las filas de totales
  Widget _buildTotalRow(String label, String value, Color color, double fontSize, FontWeight fontWeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Para que el DropdownButtonFormField funcione correctamente con el hint
extension IterableExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
// Asegúrate de añadir la propiedad nombreCompleto a tu clase Customer:
/*
class Customer {
  final int idCliente;
  final String nombre;
  final String apellido;
  // ... otras propiedades

  String get nombreCompleto => '$nombre $apellido'; 
  // ... constructor
}
*/