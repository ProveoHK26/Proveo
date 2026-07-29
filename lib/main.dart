import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/form_cotizacion_screen.dart';
import 'screens/providers_screen.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: SupabaseService.supabaseUrl,
      publishableKey: SupabaseService.supabaseAnonKey,
    );
  } catch (_) {
    // Se permite seguir aunque Supabase no esté listo del todo.
  }

  runApp(const ProveoApp());
}

class ProveoApp extends StatelessWidget {
  const ProveoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proveo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F766E),
        scaffoldBackgroundColor: const Color(0xFF07111F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF07111F),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Color(0xFF0F172A),
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        chipTheme: const ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(999))),
        ),
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/quotation': (context) => const FormCotizacionScreen(),
        '/providers': (context) => const ProvidersScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == null || settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      },
    );
  }
}
