
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/sale_controller.dart';
import '../controller/costumer_controller.dart';
import '../model/sale_model.dart';
import '../model/costumer_model.dart';
import '../theme/appcolor.dart';

class SaleTransactionView extends StatefulWidget {
  const SaleTransactionView({super.key});

  @override
  State<SaleTransactionView> createState() => _SaleTransactionViewState();
}

class _SaleTransactionViewState extends State<SaleTransactionView> {
  final SaleController _saleController = SaleController();
  final CustomerController _customerController = CustomerController();

  List<Customer> _clientes = [];
  Customer? _clienteSeleccionado;
  List<CreateSaleDetailDTO> _detalleVenta = [];

  final TextEditingController _idProductoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    try {
      final clientes = await _customerController.getActiveCustomers();
      setState(() {
        _clientes = clientes;
        if (clientes.isNotEmpty) _clienteSeleccionado = clientes.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando clientes: $e')),
      );
    }
  }

  void _agregarProducto() {
    final id = int.tryParse(_idProductoController.text);
    final cantidad = int.tryParse(_cantidadController.text);

    if (id == null || cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos del producto inválidos')),
      );
      return;
    }

    setState(() {
      _detalleVenta.add(CreateSaleDetailDTO(idProductos: id, cantidad: cantidad));
      _idProductoController.clear();
      _cantidadController.clear();
    });
  }

  void _eliminarProducto(int index) {
    setState(() {
      _detalleVenta.removeAt(index);
    });
  }

  Future<void> _guardarVenta() async {
    if (_clienteSeleccionado == null || _detalleVenta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione cliente y agregue productos')),
      );
      return;
    }

    final venta = CreateSaleDTO(
      idCliente: _clienteSeleccionado!.idCliente,
      fechaVenta: DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
      detalleVenta: _detalleVenta,
    );

    setState(() => _cargando = true);

    try {
      final response = await _saleController.insertarVenta(venta);

      if (response != null && response.result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message?.join(', ') ?? 'Venta registrada'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() => _detalleVenta.clear());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response?.message?.join(', ') ?? 'Error al registrar venta'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Venta'),
        backgroundColor: AppColors.oxfordBlue,
      ),
      backgroundColor: AppColors.lavender,
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<Customer>(
                    value: _clienteSeleccionado,
                    decoration: const InputDecoration(labelText: 'Cliente'),
                    items: _clientes
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text('${c.nombre} ${c.apellido}'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _clienteSeleccionado = v),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: _idProductoController,
                    decoration: const InputDecoration(labelText: 'ID Producto'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _agregarProducto,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar producto'),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _detalleVenta.length,
                      itemBuilder: (context, index) {
                        final d = _detalleVenta[index];
                        return Card(
                          child: ListTile(
                            title: Text('Producto ID: ${d.idProductos}'),
                            subtitle: Text('Cantidad: ${d.cantidad}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _eliminarProducto(index),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _guardarVenta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.oxfordBlue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Registrar Venta', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
