import 'package:flutter/material.dart';
import '../controller/producto_controller.dart';
import '../model/product_model.dart';

class AgregarProductoModal extends StatefulWidget {
  final Function(Product, int) onAgregar;

  const AgregarProductoModal({super.key, required this.onAgregar});

  @override
  State<AgregarProductoModal> createState() => _AgregarProductoModalState();
}

class _AgregarProductoModalState extends State<AgregarProductoModal> {
  final ProductController _productController = ProductController();
  List<Product> _productos = [];
  Product? _productoSeleccionado;
  final TextEditingController _cantidadController = TextEditingController();
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await _productController.obtenerProductosActivos();
      setState(() {
        _productos = productos;
        _cargando = false;
      });
    } catch (e) {
      setState(() => _cargando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF4F6FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('🛒 Agregar producto'),
      content: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Product>(
                    value: _productoSeleccionado,
                    items: _productos
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.nombreProducto),
                            ))
                        .toList(),
                    onChanged: (p) {
                      setState(() => _productoSeleccionado = p);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Seleccionar producto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_productoSeleccionado != null) ...[
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Precio unitario',
                        border: const OutlineInputBorder(),
                        hintText:
                            'C\$ ${_productoSeleccionado!.precio.toStringAsFixed(2)}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Agregar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF192338),
          ),
          onPressed: _productoSeleccionado == null ||
                  _cantidadController.text.isEmpty
              ? null
              : () {
                  final cantidad = int.tryParse(_cantidadController.text) ?? 1;
                  widget.onAgregar(_productoSeleccionado!, cantidad);
                  Navigator.pop(context);
                },
        ),
      ],
    );
  }
}
