import 'package:flutter/material.dart';
import '../controller/costumer_controller.dart';
import '../model/costumer_model.dart';
import '../theme/appcolor.dart';

class CustomerDetailView extends StatefulWidget {
  final Customer customer;

  const CustomerDetailView({super.key, required this.customer});

  @override
  State<CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView> {
  final CustomerController _controller = CustomerController(); // ✅ Controlador

  bool _isProcessing = false;
  bool _isActive = false; // Estado local del cliente

  @override
  void initState() {
    super.initState();
    _isActive = widget.customer.estado;
  }

  

  // 🧠 Modal de confirmación
  Future<void> _confirmarCambioEstado(bool activar) async {
    final action = activar ? 'activar' : 'desactivar';
    final id = widget.customer.idCliente;
if (id <= 0) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('ID inválido del cliente')),
  );
  return;
}
final ok = await _controller.deactivateCustomer(id); // o activateCustomer

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar $action'),
        content: Text(
            '¿Desea realmente $action al cliente "${widget.customer.nombre} ${widget.customer.apellido}"?'),
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
            child: Text(activar ? 'Activar' : 'Desactivar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _cambiarEstado(activar);
    }
  }


  // 🔄 Lógica para activar/desactivar cliente
  Future<void> _cambiarEstado(bool activar) async {
    setState(() => _isProcessing = true);
    bool success = false;

    try {
      if (activar) {
        success = await _controller.activateCustomer(widget.customer.idCliente);
      } else {
        success =
            await _controller.deactivateCustomer(widget.customer.idCliente);
      }

      if (success) {
        setState(() => _isActive = activar);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Cliente ${activar ? "activado" : "desactivado"} correctamente.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('❌ No se pudo actualizar el estado.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Error al actualizar estado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;

    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.oxfordBlue,
        title: const Text(
          'Detalles del Cliente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🧍‍♂️ Avatar del cliente
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(Icons.person,
                      size: 60, color: Color(0xFF455A64)),
                ),
                const SizedBox(height: 20),

                // 🧾 Nombre completo
                Text(
                  '${customer.nombre} ${customer.apellido}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF192338),
                  ),
                ),
                const SizedBox(height: 8),

                // 📞 Teléfono
                Text(
                  'Teléfono: ${customer.telefono}',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 4),

                // 🏠 Dirección
                Text(
                  'Dirección: ${customer.direccion}',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // 🔘 Estado visual
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isActive ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: _isActive ? Colors.green[800] : Colors.red[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),

                // 🧩 Botones de acción
                if (_isProcessing)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isActive
                            ? null
                            : () => _confirmarCambioEstado(true),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Activar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(140, 45),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: !_isActive
                            ? null
                            : () => _confirmarCambioEstado(false),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Desactivar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(140, 45),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
