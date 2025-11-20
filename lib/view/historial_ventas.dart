import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/sale_model.dart'; // Importa Sale y SaleDetail
import '../theme/appcolor.dart'; 
import '../widgets/sidebar.dart';
import '../controller/sale_controller.dart'; 

class SalesHistoryView extends StatefulWidget {
  const SalesHistoryView({super.key});

  @override
  State<SalesHistoryView> createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<SalesHistoryView> {
  final SalesController _saleController = SalesController();
  List<Sale> _ventas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllSales();
  }

  Future<void> _loadAllSales() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Usamos el método que llama al endpoint /Obtener_Ventas de tu API
      final salesData = await _saleController.obtenerTodasLasVentas();
      
      setState(() {
        // Ordenar por fecha de venta descendente (más reciente primero)
        _ventas = salesData..sort((a, b) => b.fechaVenta.compareTo(a.fechaVenta));
      });
    } catch (e) {
      _errorMessage = 'Error al cargar el historial de ventas: ${e.toString()}';
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Widgets ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lavender,
      appBar: AppBar(
        backgroundColor: AppColors.oxfordBlue,
        title: const Text("Historial de Ventas", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(authResponse: null),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.oxfordBlue))
          : _errorMessage.isNotEmpty
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)),
                ))
              : _buildSalesList(),
    );
  }

  Widget _buildSalesList() {
    if (_ventas.isEmpty) {
      return const Center(
        child: Text("No se ha registrado ninguna venta.", style: TextStyle(color: Colors.grey, fontSize: 16)),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _ventas.length,
      itemBuilder: (context, index) {
        final venta = _ventas[index];
        final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(venta.fechaVenta);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black12, width: 0.5)
          ),
          color: Colors.white,
          // Usamos ExpansionTile para mostrar el detalle al seleccionarla
          child: ExpansionTile(
            leading: const Icon(Icons.receipt, color: AppColors.oxfordBlue),
            title: Text(
              // Título principal: Fecha de la venta
              "Venta #${venta.idVenta ?? index + 1} (${formattedDate})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.oxfordBlue),
            ),
            subtitle: Text(
              // Subtítulo (Opcional, si tienes el nombre del cliente cargado)
              'Cliente ID: ${venta.idCliente}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Text(
              // Total de la venta
              "C\$${venta.total.toStringAsFixed(2)}", // Usa el getter 'total' de tu modelo Sale
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green[700]),
            ),
            children: [
              const Divider(height: 1, thickness: 1, color: Colors.black12),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalle de Productos:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    // Lista de detalles de productos (DetalleVenta)
                    ...venta.detalleVenta.map((detalle) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${detalle.cantidad}x ${detalle.nombreProducto}",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ),
                          Text(
                            "C\$${detalle.lineaTotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}