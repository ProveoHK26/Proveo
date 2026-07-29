import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/provider_catalog.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://sjepgdhpsnflubuzkaen.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNqZXBnZGhwc25mbHVidXprYWVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODUyNjk4MDQsImV4cCI6MjEwMDg0NTgwNH0.YG_ZSVZpVdRLg42tUFg6UHsKnS5lM9ncozZG3b-__mg';

  static SupabaseClient? getClientOrNull() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  static Future<void> seedDemoUsers() async {
    try {
      final client = getClientOrNull();
      if (client == null) {
        return;
      }

      final users = [
        {
          'email': 'jamesmillardtaylorrocha3@gmail.com',
          'password': 'EIDOLONSLAYEr007',
          'full_name': 'Loki',
          'access_role': 'admin',
          'user_type': 'proveedor',
          'quote_limit': 999999,
          'supplier_limit': 999999,
          'message_limit': 999999,
        },
        {
          'email': 'jamesmillardtaylorrocha4@gmail.com',
          'password': '123456789',
          'full_name': 'Auditor',
          'access_role': 'auditor',
          'user_type': 'comprador',
          'quote_limit': 1,
          'supplier_limit': 1,
          'message_limit': 999999,
        },
      ];

      for (final userData in users) {
        final email = userData['email'] as String;
        final password = userData['password'] as String;
        final fullName = userData['full_name'] as String;
        final accessRole = userData['access_role'] as String;
        final userType = userData['user_type'] as String;
        final quoteLimit = userData['quote_limit'] as int;
        final supplierLimit = userData['supplier_limit'] as int;
        final messageLimit = userData['message_limit'] as int;

        try {
          final existing = await client.from('profiles').select('id').eq('email', email).maybeSingle();
          if (existing != null) {
            continue;
          }

          final response = await client.auth.signUp(email: email, password: password);
          final userId = response.user?.id;
          if (userId != null) {
            await client.from('profiles').upsert({
              'id': userId,
              'full_name': fullName,
              'email': email,
              'phone': '',
              'user_type': userType,
              'access_role': accessRole,
              'quote_limit': quoteLimit,
              'supplier_limit': supplierLimit,
              'message_limit': messageLimit,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            }, onConflict: 'id');
          }
        } catch (_) {
          // Ignora errores de seed para no romper el arranque de la app.
        }
      }
    } catch (_) {
      // Si la inicialización de Supabase aún no está lista, se ignora.
    }
  }

  static Future<Map<String, dynamic>?> getCurrentProfile() async {
    try {
      final client = getClientOrNull();
      if (client == null) {
        return null;
      }

      final user = client.auth.currentUser;
      if (user == null) {
        return null;
      }

      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      return response;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getSuppliers() async {
    try {
      final client = getClientOrNull();
      if (client == null) {
        return [];
      }

      try {
        final response = await client
            .from('suppliers')
            .select('id, name, contact_name, email, phone, category, specialty, rating, created_at')
            .order('created_at', ascending: false);

        return List<Map<String, dynamic>>.from(response);
      } catch (_) {
        final response = await client
            .from('suppliers')
            .select('id, name, contact_name, email, phone, category, created_at')
            .order('created_at', ascending: false);

        return List<Map<String, dynamic>>.from(response);
      }
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveSupplier({
    required String name,
    required String contactName,
    required String email,
    required String phone,
    required String category,
    required String specialty,
    required String rating,
  }) async {
    final client = getClientOrNull();
    if (client == null) {
      return;
    }

    try {
      await client.from('suppliers').insert({
        'name': name,
        'contact_name': contactName,
        'email': email,
        'phone': phone,
        'category': category,
        'specialty': specialty,
        'rating': rating,
      });
    } catch (_) {
      try {
        await client.from('suppliers').insert({
          'name': name,
          'contact_name': contactName,
          'email': email,
          'phone': phone,
          'category': category,
        });
      } catch (_) {
        // Se ignora si la tabla no está todavía preparada en Supabase.
      }
    }
  }

  static Future<void> seedDemoSuppliers() async {
    try {
      final client = getClientOrNull();
      if (client == null) {
        return;
      }

      final existing = await client.from('suppliers').select('id').limit(1);
      if (existing.isNotEmpty) {
        return;
      }

      for (final provider in getDemoProviders()) {
        await saveSupplier(
          name: provider.name,
          contactName: provider.contactName,
          email: provider.email,
          phone: provider.phone,
          category: provider.category,
          specialty: provider.specialty,
          rating: provider.rating,
        );
      }
    } catch (_) {
      // Se ignora si la tabla aún no está lista.
    }
  }

  static Future<void> createProfileForUser({
    required String userId,
    required String email,
    String? fullName,
    String userType = 'comprador',
    String accessRole = 'user',
    int quoteLimit = 999999,
    int supplierLimit = 999999,
    int messageLimit = 999999,
  }) async {
    try {
      final client = getClientOrNull();
      if (client == null) {
        return;
      }

      await client.from('profiles').upsert({
        'id': userId,
        'full_name': fullName ?? email.split('@').first,
        'email': email,
        'phone': '',
        'user_type': userType,
        'access_role': accessRole,
        'quote_limit': quoteLimit,
        'supplier_limit': supplierLimit,
        'message_limit': messageLimit,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
    } catch (_) {
      // Se ignora si la tabla o permisos aún no están listos.
    }
  }

  static Future<void> saveProfile({
    required String fullName,
    required String phone,
    required String email,
    required String userType,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return;
    }

    final client = getClientOrNull();
    if (client == null) {
      return;
    }

    try {
      await client.auth.updateUser(UserAttributes(email: email));
    } catch (_) {
      // Se deja el cambio de email solo en el perfil si la autenticación no lo permite.
    }

    try {
      await client.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'user_type': userType,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');
    } catch (_) {
      // Se ignora si la tabla o permisos aún no están listos.
    }
  }
}
