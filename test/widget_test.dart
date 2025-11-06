// Testes de Widget para o Meu Fórum
// Estes testes verificam se a interface do usuário funciona corretamente

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meu_forum/main.dart';

void main() {
  group('Widget Tests - App Principal', () {
    testWidgets('App deve inicializar e mostrar loading', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MeuForumApp());

      // Assert - Deve mostrar um indicador de carregamento
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App deve ter o título correto', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MeuForumApp());

      // Assert - Verifica se o MaterialApp foi criado
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Meu Fórum');
    });

    testWidgets('App deve ter debugShowCheckedModeBanner desabilitado', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MeuForumApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('App deve usar Material 3', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MeuForumApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, true);
    });
  });
}
