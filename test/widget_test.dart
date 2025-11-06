// Testes de Widget para o Meu Fórum
// Estes testes verificam componentes básicos da interface do usuário

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tests - Componentes Básicos', () {
    testWidgets('CircularProgressIndicator deve ser renderizado', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Scaffold com AppBar deve ser renderizado corretamente', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Teste'),
            ),
            body: const Center(
              child: Text('Conteúdo'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Teste'), findsOneWidget);
      expect(find.text('Conteúdo'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('TextField deve aceitar entrada de texto', (WidgetTester tester) async {
      // Arrange
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'Texto de teste');

      // Assert
      expect(controller.text, 'Texto de teste');
      expect(find.text('Texto de teste'), findsOneWidget);
    });

    testWidgets('ElevatedButton deve ser clicável', (WidgetTester tester) async {
      // Arrange
      bool wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () => wasPressed = true,
              child: const Text('Clique aqui'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, isTrue);
      expect(find.text('Clique aqui'), findsOneWidget);
    });

    testWidgets('ListView deve renderizar múltiplos itens', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
                ListTile(title: Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });
  });
}
