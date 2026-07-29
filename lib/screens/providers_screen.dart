import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/provider_catalog.dart';
import '../services/supabase_service.dart';

class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _categoryController = TextEditingController();
  final _searchController = TextEditingController();
  bool _isLoading = false;
  int _visibleCount = 6;

  List<Map<String, String>> _providers = [];
  List<Map<String, String>> _allProviders = [];

  @override
  void initState() {
    super.initState();
    _allProviders = _buildInitialCatalog();
    _providers = _allProviders.take(_visibleCount).toList();
    _loadProviders();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _categoryController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _buildInitialCatalog() {
    return getDemoProviders().map((provider) => {
          'name': provider.name,
          'contact': provider.contactName,
          'email': provider.email,
          'phone': provider.phone,
          'category': provider.category,
          'specialty': provider.specialty,
          'rating': provider.rating,
        }).toList();
  }

  Map<String, String> _mapRemoteProvider(Map<String, dynamic> provider) {
    final name = provider['name']?.toString() ?? 'Proveedor';
    final category = provider['category']?.toString() ?? 'General';
    final contact = provider['contact_name']?.toString() ?? 'Equipo comercial';
    final email = provider['email']?.toString() ?? 'contacto@proveo.com';
    final phone = provider['phone']?.toString() ?? '+34 600 000 000';
    final specialty = provider['specialty']?.toString() ?? _defaultSpecialtyFor(name, category);
    final rating = provider['rating']?.toString() ?? '4.7';

    return {
      'name': name,
      'contact': contact,
      'email': email,
      'phone': phone,
      'category': category,
      'specialty': specialty,
      'rating': rating,
      'description': _defaultDescriptionFor(name, category, specialty),
    };
  }

  String _defaultSpecialtyFor(String name, String category) {
    if (category.toLowerCase().contains('tec')) {
      return 'Hardware y equipos';
    }
    if (category.toLowerCase().contains('log')) {
      return 'Operación y transporte';
    }
    if (category.toLowerCase().contains('mate')) {
      return 'Materiales industriales';
    }
    if (category.toLowerCase().contains('pack')) {
      return 'Embalaje y envases';
    }
    if (name.toLowerCase().contains('acme')) {
      return 'Materias primas industriales';
    }
    return 'Suministros corporativos';
  }

  String _defaultDescriptionFor(String name, String category, String specialty) {
    return '$name destaca por ofrecer $specialty dentro del ámbito de $category, con un enfoque ágil en operaciones, tiempos de entrega y calidad comercial.';
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);

    try {
      await SupabaseService.seedDemoSuppliers();
      final remoteProviders = await SupabaseService.getSuppliers();
      if (!mounted) return;

      if (remoteProviders.isNotEmpty) {
        final mapped = remoteProviders.map(_mapRemoteProvider).toList();
        setState(() {
          _allProviders = mapped;
          _visibleCount = mapped.length < 6 ? mapped.length : 6;
          _providers = _allProviders.take(_visibleCount).toList();
        });
        return;
      }

      setState(() {
        _allProviders = _buildInitialCatalog();
        _visibleCount = 6;
        _providers = _allProviders.take(_visibleCount).toList();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _allProviders = _buildInitialCatalog();
        _visibleCount = 6;
        _providers = _allProviders.take(_visibleCount).toList();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProvider() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del proveedor es obligatorio')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final newProvider = {
      'name': _nameController.text.trim(),
      'contact': _contactController.text.trim().isEmpty ? 'Sin contacto' : _contactController.text.trim(),
      'email': _emailController.text.trim().isEmpty ? 'sin-email@proveo.com' : _emailController.text.trim(),
      'phone': _phoneController.text.trim().isEmpty ? 'No disponible' : _phoneController.text.trim(),
      'category': _categoryController.text.trim().isEmpty ? 'General' : _categoryController.text.trim(),
      'specialty': 'Suministro personalizado',
      'rating': '4.7',
      'description': 'Proveedor añadido desde Proveo con foco en respuestas rápidas y coordinación de pedidos.',
    };

    try {
      await SupabaseService.saveSupplier(
        name: newProvider['name'] ?? 'Proveedor',
        contactName: newProvider['contact'] ?? 'Sin contacto',
        email: newProvider['email'] ?? 'contacto@proveo.com',
        phone: newProvider['phone'] ?? 'No disponible',
        category: newProvider['category'] ?? 'General',
        specialty: newProvider['specialty'] ?? 'Suministro personalizado',
        rating: newProvider['rating'] ?? '4.7',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proveedor guardado correctamente')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se añadió al catálogo local: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _allProviders.insert(0, newProvider);
          _providers = _allProviders.take(_visibleCount).toList();
          _nameController.clear();
          _contactController.clear();
          _emailController.clear();
          _phoneController.clear();
          _categoryController.clear();
        });
      }
    }
  }

  @override
  void _openProviderDetail(Map<String, String> provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFCCFBF1)]), borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.business_rounded, color: Color(0xFF2563EB), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(provider['name'] ?? 'Proveedor', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(provider['category'] ?? 'General', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFF), borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(icon: Icons.star_rounded, label: 'Valoración', value: provider['rating'] ?? '4.7'),
                    _DetailRow(icon: Icons.category_rounded, label: 'Especialidad', value: provider['specialty'] ?? 'Sin especialidad'),
                    _DetailRow(icon: Icons.person_outline_rounded, label: 'Contacto', value: provider['contact'] ?? 'Sin contacto'),
                    _DetailRow(icon: Icons.email_rounded, label: 'Correo', value: provider['email'] ?? 'No disponible'),
                    _DetailRow(icon: Icons.phone_rounded, label: 'Teléfono', value: provider['phone'] ?? 'No disponible'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFF0F766E)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(provider['description'] ?? 'Proveedor activo en Proveo.', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Contacto abierto con ${provider['name'] ?? 'este proveedor'}')),
                        );
                      },
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: const Text('Contactar'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Cerrar'),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0F766E))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, String>> get _filteredProviders {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _providers;
    }

    return _providers.where((provider) {
      final haystack = [
        provider['name'],
        provider['category'],
        provider['specialty'],
        provider['contact'],
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver a la página principal',
          icon: const Icon(Icons.home_rounded),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        ),
        title: const Text('Gestionar proveedores'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF2563EB), Color(0xFF0F766E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Catálogo de proveedores', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Explora una red más amplia de empresas con contacto real, especialidades de producto y valoración de rendimiento.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: 'Buscar proveedor',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filteredProviders.map((provider) {
                  return Chip(
                    avatar: const Icon(Icons.business_rounded, size: 18),
                    label: Text(provider['name'] ?? ''),
                    backgroundColor: const Color(0xFFDBEAFE),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _visibleCount >= _allProviders.length
                      ? null
                      : () {
                          setState(() {
                            _visibleCount = (_visibleCount + 6).clamp(0, _allProviders.length);
                            _providers = _allProviders.take(_visibleCount).toList();
                          });
                        },
                  icon: const Icon(Icons.expand_more_rounded),
                  label: Text(_visibleCount >= _allProviders.length ? 'Todos los proveedores cargados' : 'Ver más proveedores'),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF0F766E))),
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
                      Text('Agregar nuevo proveedor', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text('Completa los datos y se añadirá al catálogo visible para la operación.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre del proveedor', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _contactController,
                        decoration: const InputDecoration(labelText: 'Nombre de contacto', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Correo', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _categoryController,
                        decoration: const InputDecoration(labelText: 'Categoría', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _saveProvider,
                          icon: _isLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.save_rounded),
                          label: Text(_isLoading ? 'Guardando...' : 'Guardar proveedor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Proveedores activos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ..._filteredProviders.map((provider) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _openProviderDetail(provider),
                      borderRadius: BorderRadius.circular(20),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFCCFBF1)]), borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.business_rounded, color: Color(0xFF0F766E)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(provider['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(provider['category'] ?? 'General', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                                    const SizedBox(height: 2),
                                    Text('Especialidad: ${provider['specialty']}', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 2),
                                    Text('${provider['contact']} • ${provider['phone']} • ${provider['email']}', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF64748B)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0F766E)),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
