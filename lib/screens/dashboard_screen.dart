import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _fullName = 'Usuario';
  String _email = '';
  String _phone = '';
  String _userType = 'comprador';
  bool _isLoading = true;
  int _supplierCount = 0;
  int _quoteCount = 3;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedUserType = 'comprador';

  final List<_ActivityItem> _recentActivity = [
    _ActivityItem('Cotización enviada', 'Lámpara industrial • 12 unidades', 'Hace 35 min', Icons.receipt_long_rounded),
    _ActivityItem('Proveedor contactado', 'Northwind Ltd. respondió en 10 min', 'Hace 2 h', Icons.handshake_rounded),
    _ActivityItem('Perfil actualizado', 'Cambiaste tu contacto y rol', 'Ayer', Icons.person_outline_rounded),
  ];

  final List<_ProviderSpotlight> _providerSpotlights = [
    _ProviderSpotlight('Northwind Ltd.', 'Logística y transporte', '4.9', Icons.local_shipping_rounded),
    _ProviderSpotlight('BluePeak', 'Tecnología y hardware', '4.8', Icons.devices_rounded),
    _ProviderSpotlight('Acme Supplies', 'Materiales industriales', '4.7', Icons.business_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadSupplierSummary();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final profile = await SupabaseService.getCurrentProfile();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _fullName = profile?['full_name'] ?? 'Usuario';
      _email = profile?['email'] ?? '';
      _phone = profile?['phone'] ?? '';
      _userType = profile?['user_type'] ?? 'comprador';
      _selectedUserType = _userType;
      _nameController.text = _fullName;
      _phoneController.text = _phone;
      _emailController.text = _email;
    });
  }

  Future<void> _loadSupplierSummary() async {
    final suppliers = await SupabaseService.getSuppliers();
    if (!mounted) return;

    setState(() {
      _supplierCount = suppliers.length;
    });
  }

  Future<void> _openProfileEditor() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu perfil', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Ajusta tu identidad, contacto y rol para que el equipo vea la información correcta.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedUserType,
                decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'comprador', child: Text('Comprador')),
                  DropdownMenuItem(value: 'proveedor', child: Text('Proveedor')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedUserType = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    setState(() => _isLoading = true);
                    await SupabaseService.saveProfile(
                      fullName: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      userType: _selectedUserType,
                    );
                    await _loadProfile();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado')),
                    );
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Guardar cambios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStatus = _userType.isEmpty ? 'comprador' : _userType;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Dashboard Proveo'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: _openProfileEditor,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF07111F), Color(0xFF0F172A), Color(0xFF1D4ED8)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF2563EB), Color(0xFF0F766E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: const Color(0xFF0F766E).withOpacity(0.2), blurRadius: 24, offset: const Offset(0, 12))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Panel de operaciones', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Gestiona cotizaciones, proveedores y tu perfil desde un solo lugar con una vista más clara y accionable.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _ActionChip(label: 'Nueva cotización', icon: Icons.add_circle_outline_rounded),
                        _ActionChip(label: 'Seguimiento rápido', icon: Icons.speed_rounded),
                        _ActionChip(label: 'Proveedores verificados', icon: Icons.verified_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _SummaryCard(title: 'Cotizaciones', value: '$_quoteCount', icon: Icons.receipt_long_rounded, accent: const Color(0xFFCCFBF1)),
                  _SummaryCard(title: 'Proveedores', value: '$_supplierCount', icon: Icons.handshake_rounded, accent: const Color(0xFFECFEFF)),
                  _SummaryCard(title: 'Mensajes', value: '4', icon: Icons.chat_bubble_outline_rounded, accent: const Color(0xFFFCE7F3)),
                ],
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFCCFBF1)]), borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.person_outline_rounded, color: Color(0xFF2563EB), size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(_fullName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(color: const Color(0xFFECFEFF), borderRadius: BorderRadius.circular(999)),
                                    child: Text(userStatus.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF115E59))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(_email, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                              const SizedBox(height: 6),
                              Text('Contacto: ${_phone.isEmpty ? "Añade tu número" : _phone}', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/quotation'),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    label: const Text('Nueva cotización'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/providers'),
                    icon: const Icon(Icons.group_work_rounded),
                    label: const Text('Ver proveedores'),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0F766E))),
                  ),
                  OutlinedButton.icon(
                    onPressed: _openProfileEditor,
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('Editar perfil'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Actividad reciente', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFECFEFF), borderRadius: BorderRadius.circular(999)),
                            child: const Text('En vivo', style: TextStyle(color: Color(0xFF115E59), fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._recentActivity.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(12)),
                                  child: Icon(item.icon, color: const Color(0xFF0F766E), size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 2),
                                      Text(item.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                    ],
                                  ),
                                ),
                                Text(item.time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Proveedores destacados', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                          TextButton(onPressed: () => Navigator.pushNamed(context, '/providers'), child: const Text('Ver todos')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._providerSpotlights.map((provider) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: const Color(0xFFECFEFF), borderRadius: BorderRadius.circular(12)),
                                    child: Icon(provider.icon, color: const Color(0xFF0F766E)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(provider.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 2),
                                        Text(provider.category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(999)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFF0F766E)),
                                        const SizedBox(width: 4),
                                        Text(provider.rating, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F766E))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon, required this.accent});

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: const Color(0xFF0F766E)),
              ),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem(this.title, this.subtitle, this.time, this.icon);

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
}

class _ProviderSpotlight {
  const _ProviderSpotlight(this.name, this.category, this.rating, this.icon);

  final String name;
  final String category;
  final String rating;
  final IconData icon;
}
