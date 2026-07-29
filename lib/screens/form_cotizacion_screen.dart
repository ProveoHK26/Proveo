import 'package:flutter/material.dart';
import '../utils/validators.dart';

class FormCotizacionScreen extends StatefulWidget {
  const FormCotizacionScreen({super.key});

  @override
  State<FormCotizacionScreen> createState() => _FormCotizacionScreenState();
}

class _FormCotizacionScreenState extends State<FormCotizacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _deliveryController = TextEditingController(text: '2-3 días');
  final List<String> _deliveryOptions = ['1 día', '2-3 días', '1 semana', 'A negociar'];

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitud de cotización'),
        elevation: 0,
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: const Color(0xFF0F172A),
      ),
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF115E59)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cotiza tu pedido', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text('Comparte tus necesidades y recibe respuestas de proveedores listos para trabajar, con una propuesta más clara y detallada.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _productController,
                              decoration: const InputDecoration(labelText: 'Nombre del producto', prefixIcon: Icon(Icons.shopping_bag_outlined), border: OutlineInputBorder()),
                              validator: (value) => Validators.required(value, fieldName: 'Producto'),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _quantityController,
                              decoration: const InputDecoration(labelText: 'Cantidad', prefixIcon: Icon(Icons.numbers_outlined), border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: (value) => Validators.required(value, fieldName: 'Cantidad'),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(labelText: 'Precio estimado', prefixIcon: Icon(Icons.attach_money_rounded), border: OutlineInputBorder()),
                              keyboardType: TextInputType.number,
                              validator: Validators.price,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _deliveryController.text,
                              decoration: const InputDecoration(labelText: 'Plazo estimado', prefixIcon: Icon(Icons.local_shipping_rounded), border: OutlineInputBorder()),
                              items: _deliveryOptions.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  _deliveryController.text = value;
                                }
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _notesController,
                              maxLines: 4,
                              decoration: const InputDecoration(labelText: 'Notas adicionales', prefixIcon: Icon(Icons.notes_rounded), border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cotización enviada correctamente')),
                                    );
                                    _productController.clear();
                                    _quantityController.clear();
                                    _priceController.clear();
                                    _notesController.clear();
                                    _deliveryController.text = '2-3 días';
                                  }
                                },
                                icon: const Icon(Icons.send_rounded),
                                label: const Text('Enviar cotización'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: const Color(0xFF0F766E),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Qué incluye la solicitud', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          _InfoRow(icon: Icons.verified_rounded, text: 'Comparte el producto y el volumen exacto'),
                          _InfoRow(icon: Icons.timer_rounded, text: 'Recibe respuesta con plazo y precio estimado'),
                          _InfoRow(icon: Icons.groups_rounded, text: 'Conecta con proveedores verificados en pocos minutos'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: const Color(0xFF0F766E)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
