import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../model/costumer_model.dart';
import '../controller/costumer_controller.dart';
import '../model/venta_model.dart';



class CustomerDetailView extends StatefulWidget {
  final Customer customer;

  const CustomerDetailView({super.key, required this.customer});

  @override
  State<CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView> {
  final CustomerController _controller = CustomerController();

  late Future<List<Sale>> _ventasFuture;

  @override
  void initState() {
    super.initState();
    _ventasFuture = _controller.getSalesByCustomer(widget.customer.idCliente);
  }

  // Confirmar activación o desactivación
  void _confirmarCambioEstado(bool activar) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${activar ? 'Activar' : 'Desactivar'} cliente'),
        content: Text(
          '¿Deseas ${activar ? 'activar' : 'desactivar'} a ${widget.customer.nombre}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: activar ? Colors.green : Colors.red,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool result = activar
          ? await _controller.activateCustomer(widget.customer.idCliente)
          : await _controller.deactivateCustomer(widget.customer.idCliente);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result
                ? 'Cliente ${activar ? 'activado' : 'desactivado'} correctamente.'
                : 'Error al actualizar el estado.'),
            backgroundColor: result ? Colors.green : Colors.red,
          ),
        );

        if (result) {
          setState(() {
            widget.customer.setField('Estado', activar);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${customer.nombre}'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta con información general del cliente
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${customer.nombre} ${customer.apellido}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Teléfono: ${customer.telefono}'),
                    Text('Dirección: ${customer.direccion}'),
                    Text('Estado: ${customer.estado ? 'Activo' : 'Inactivo'}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.block),
                          label: const Text('Desactivar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: customer.estado
                              ? () => _confirmarCambioEstado(false)
                              : null,
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Activar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: !customer.estado
                              ? () => _confirmarCambioEstado(true)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Historial de compras
            Text(
              'Historial de compras',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            FutureBuilder<List<Sale>>(
              future: _ventasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error al cargar ventas: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay compras registradas.'));
                }

                final ventas = snapshot.data!;
                return Column(
                  children: ventas.map((venta) {
                    final fecha =
                        DateFormat('dd/MM/yyyy').format(venta.fechaVenta);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha: $fecha',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            ...venta.detalleVenta.map((d) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(d.nombreProducto,
                                          style:
                                              const TextStyle(fontSize: 15)),
                                      Text(
                                        '\$${d.lineaTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
