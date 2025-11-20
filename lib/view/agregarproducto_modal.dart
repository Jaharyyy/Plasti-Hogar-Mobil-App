import 'package:flutter/material.dart';
import '../controller/producto_controller.dart';
import '../model/product_model.dart';
import '../theme/appcolor.dart'; 

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
  // --- AÑADIDO: Controlador para el campo de precio unitario ---
  final TextEditingController _precioUnitarioController = TextEditingController();
  // --- FIN AÑADIDO ---
  bool _cargando = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cargarProductos();
    // Inicializar el precio unitario si ya hay un producto seleccionado (poco probable en un modal nuevo)
    _actualizarPrecioUnitario(); 
  }
  
  @override
  void dispose() {
    _cantidadController.dispose();
    // --- AÑADIDO: Disponer el controlador de precio unitario ---
    _precioUnitarioController.dispose();
    // --- FIN AÑADIDO ---
    super.dispose();
  }

  Future<void> _cargarProductos() async {
    try {
      final productos = await _productController.obtenerProductosActivos();
      setState(() {
        _productos = productos;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar productos: $e')),
        );
      }
    }
  }

  // --- NUEVO MÉTODO: Para actualizar el controlador del precio ---
  void _actualizarPrecioUnitario() {
    if (_productoSeleccionado != null) {
      _precioUnitarioController.text = 'C\$ ${_productoSeleccionado!.precio.toStringAsFixed(2)}';
    } else {
      _precioUnitarioController.text = ''; // Limpiar si no hay producto seleccionado
    }
  }
  // --- FIN NUEVO MÉTODO ---

  void _intentarAgregarProducto() {
    if (_formKey.currentState!.validate() && _productoSeleccionado != null) {
      final cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;
      
      if (cantidad <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La cantidad debe ser mayor que cero.')),
          );
        }
        return;
      }

      widget.onAgregar(_productoSeleccionado!, cantidad);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  static const Color accentColor = AppColors.oxfordBlue; 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      
      title: const Text(
        'Agregar Producto', 
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          color: accentColor
        )
      ),
      
      content: _cargando
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Selector de Producto
                  DropdownButtonFormField<Product>(
                    value: _productoSeleccionado,
                    items: _productos
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.nombreProducto, style: const TextStyle(color: accentColor)), 
                            ))
                        .toList(),
                    onChanged: (p) {
                      setState(() {
                        _productoSeleccionado = p;
                        _actualizarPrecioUnitario(); // --- AÑADIDO: Llama a actualizar cuando el producto cambia ---
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null ? 'Seleccione un producto' : null,
                  ),
                  const SizedBox(height: 15),

                  // Precio Unitario (Ahora usando TextEditingController)
                  if (_productoSeleccionado != null) ...[
                    TextFormField(
                      controller: _precioUnitarioController, // --- AÑADIDO: Usa el controlador ---
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Precio unitario',
                        border: OutlineInputBorder(),
                        // hintText ya no es necesario ya que el controlador maneja el texto
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green), // Estilo para el texto del precio
                    ),
                    const SizedBox(height: 15),
                  
                    // Campo Cantidad
                    TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cantidad a agregar',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingrese la cantidad';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Debe ser un número entero';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
      actions: [
        TextButton(
          child: const Text('CANCELAR', style: TextStyle(color: Colors.grey)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text('AGREGAR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
          onPressed: _intentarAgregarProducto,
        ),
      ],
    );
  }
}