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

  //editar dtos de un cliente
  void _mostrarModalEditarCliente(BuildContext context) {
  final TextEditingController nombreController =
      TextEditingController(text: widget.customer.nombre);
  final TextEditingController apellidoController =
      TextEditingController(text: widget.customer.apellido);
  final TextEditingController telefonoController =
      TextEditingController(text: widget.customer.telefono);
  final TextEditingController direccionController =
      TextEditingController(text: widget.customer.direccion);

  bool estadoActual = widget.customer.estado;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Editar Cliente',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF192338),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nombreController, 'Nombre'),
              const SizedBox(height: 8),
              _buildTextField(apellidoController, 'Apellido'),
              const SizedBox(height: 8),
              _buildTextField(telefonoController, 'Teléfono'),
              const SizedBox(height: 8),
              _buildTextField(direccionController, 'Dirección'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Activo: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Switch(
                    value: estadoActual,
                    onChanged: (value) {
                      setState(() {
                        estadoActual = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final actualizado = Customer(
                idCliente: widget.customer.idCliente,
                idEmpleados: widget.customer.idEmpleados,
                nombre: nombreController.text,
                apellido: apellidoController.text,
                telefono: telefonoController.text,
                direccion: direccionController.text,
                estado: estadoActual,
              );

              bool result = await _controller.updateCustomer(actualizado);

              if (result && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cliente actualizado correctamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
                setState(() {
                  // Actualiza la vista con los nuevos datos
                  widget.customer.setField('Nombre', actualizado.nombre);
                  widget.customer.setField('Apellido', actualizado.apellido);
                  widget.customer.setField('Telefono', actualizado.telefono);
                  widget.customer.setField('Direccion', actualizado.direccion);
                  widget.customer.setField('Estado', actualizado.estado);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al actualizar el cliente'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}
Widget _buildTextField(TextEditingController controller, String label) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF192338)),
      ),
    ),
  );
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
                    
                        //btn editar
                          Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarModalEditarCliente(context);
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text("Editar Cliente"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        
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
