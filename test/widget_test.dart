import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:proveo/main.dart';
import 'package:proveo/screens/providers_screen.dart';

void main() {
  testWidgets('renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProveoApp());

    expect(find.text('Accede a Proveo'), findsOneWidget);
  });

  testWidgets('shows validation errors when login form is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const ProveoApp());

    final formKey = tester.widget<Form>(find.byType(Form)).key as GlobalKey<FormState>;
    formKey.currentState?.validate();
    await tester.pump();

    expect(find.text('El correo es obligatorio'), findsOneWidget);
    expect(find.text('La contraseña debe tener al menos 6 caracteres'), findsOneWidget);
  });

  testWidgets('shows a search field in the providers screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProvidersScreen()));

    expect(find.text('Buscar proveedor'), findsOneWidget);
  });
}
