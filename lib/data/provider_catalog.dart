class ProviderEntry {
  const ProviderEntry({
    required this.name,
    required this.contactName,
    required this.email,
    required this.phone,
    required this.category,
    required this.specialty,
    required this.rating,
  });

  final String name;
  final String contactName;
  final String email;
  final String phone;
  final String category;
  final String specialty;
  final String rating;
}

List<ProviderEntry> getDemoProviders() {
  return const [
    ProviderEntry(
      name: 'Northwind Ltd.',
      contactName: 'Carlos Vega',
      email: 'carlos.vega@northwind.com',
      phone: '+34 600 111 222',
      category: 'Logística',
      specialty: 'Transporte y distribución',
      rating: '4.9',
    ),
    ProviderEntry(
      name: 'BluePeak',
      contactName: 'Marta Ruiz',
      email: 'marta.ruiz@bluepeak.com',
      phone: '+34 610 222 333',
      category: 'Tecnología',
      specialty: 'Hardware y equipos',
      rating: '4.8',
    ),
    ProviderEntry(
      name: 'Acme Supplies',
      contactName: 'Laura Pérez',
      email: 'laura.perez@acme.com',
      phone: '+34 620 333 444',
      category: 'Materiales',
      specialty: 'Materias primas industriales',
      rating: '4.7',
    ),
    ProviderEntry(
      name: 'EcoFlex SA',
      contactName: 'Javier Soler',
      email: 'javier@ecoflex.es',
      phone: '+34 630 444 555',
      category: 'Sostenibilidad',
      specialty: 'Packaging ecológico',
      rating: '4.9',
    ),
    ProviderEntry(
      name: 'PrimeSource',
      contactName: 'Elena Torres',
      email: 'elena@primesource.es',
      phone: '+34 640 555 666',
      category: 'Compras',
      specialty: 'Componentes de oficina',
      rating: '4.6',
    ),
    ProviderEntry(
      name: 'MecanoWork',
      contactName: 'Pedro Ibarra',
      email: 'pedro@mecanowork.es',
      phone: '+34 650 666 777',
      category: 'Mecánica',
      specialty: 'Piezas industriales',
      rating: '4.8',
    ),
    ProviderEntry(
      name: 'Delta Industrial',
      contactName: 'Sofía Ramos',
      email: 'sofia@deltaindustrial.es',
      phone: '+34 660 777 888',
      category: 'Producción',
      specialty: 'Herramientas y mantenimiento',
      rating: '4.5',
    ),
    ProviderEntry(
      name: 'Vita Goods',
      contactName: 'Nicolás Ortega',
      email: 'nicolas@vitagoods.es',
      phone: '+34 670 888 999',
      category: 'Consumibles',
      specialty: 'Productos de limpieza',
      rating: '4.7',
    ),
    ProviderEntry(
      name: 'Atlas Logistics',
      contactName: 'Mireia Gómez',
      email: 'mireia@atlaslogistics.es',
      phone: '+34 680 999 000',
      category: 'Logística',
      specialty: 'Transporte urgente',
      rating: '4.9',
    ),
    ProviderEntry(
      name: 'UrbanTech',
      contactName: 'Iñigo Castro',
      email: 'inigo@urbantech.es',
      phone: '+34 690 000 111',
      category: 'Tecnología',
      specialty: 'Monitores y periféricos',
      rating: '4.8',
    ),
    ProviderEntry(
      name: 'GreenPack',
      contactName: 'Ana Belmonte',
      email: 'ana@greenpack.es',
      phone: '+34 700 111 222',
      category: 'Packaging',
      specialty: 'Envases y embalaje',
      rating: '4.6',
    ),
    ProviderEntry(
      name: 'Nova Supplies',
      contactName: 'Rubén Flores',
      email: 'ruben@novasupplies.es',
      phone: '+34 710 222 333',
      category: 'Operaciones',
      specialty: 'Suministros de oficina',
      rating: '4.7',
    ),
  ];
}
