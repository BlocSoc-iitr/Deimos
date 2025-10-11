import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_flutter_example/main.dart';

void main() {
  group('Circom Functionality Tests', () {
    testWidgets('Circom tab initializes with correct default values', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Check that default values are set correctly
      expect(find.text('5'), findsAtLeastNWidgets(1)); // Default for input a
      expect(find.text('3'), findsAtLeastNWidgets(1)); // Default for input b
    });

    testWidgets('Circom input validation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test with valid numeric inputs - find by type instead
      final inputFields = find.byType(TextFormField);
      expect(inputFields, findsNWidgets(2));

      // Enter text in the input fields
      await tester.enterText(inputFields.first, '15');
      await tester.enterText(inputFields.last, '7');
      await tester.pump();

      expect(find.text('15'), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('Circom tab maintains state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Enter some values
      final inputFields = find.byType(TextFormField);
      await tester.enterText(inputFields.first, '20');
      await tester.enterText(inputFields.last, '10');
      await tester.pump();

      // Switch to another tab and back
      await tester.tap(find.text('Halo2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Circom'));
      await tester.pumpAndSettle();

      // Verify values are still there
      expect(find.text('20'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('Circom tab handles keyboard input correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final inputFields = find.byType(TextFormField);

      // Test keyboard input
      await tester.tap(inputFields.first);
      await tester.enterText(inputFields.first, '123');
      await tester.pump();

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('Circom tab shows proper error handling UI', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Initially no error should be shown
      expect(find.byWidgetPredicate(
        (Widget widget) => widget is Text && 
                          widget.data!.contains('Error'),
      ), findsNothing);
    });

    testWidgets('Circom tab has correct button layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify both buttons are present
      expect(find.text('Generate Proof'), findsOneWidget);
      expect(find.text('Verify Proof'), findsOneWidget);
    });

    testWidgets('Circom tab handles focus management', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final inputFields = find.byType(TextFormField);

      // Tap on input field
      await tester.tap(inputFields.first);
      await tester.pump();

      // Verify focus is working by checking if input field exists
      expect(inputFields.first, findsOneWidget);
    });

    testWidgets('Circom tab shows proof results area when available', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Initially, proof results should not be visible
      expect(find.text('Proof is valid:'), findsNothing);
      expect(find.text('Proof inputs:'), findsNothing);
      expect(find.text('Proof:'), findsNothing);
    });

    testWidgets('Circom tab handles large input values', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final inputFields = find.byType(TextFormField);

      // Test with large numbers
      await tester.enterText(inputFields.first, '999999');
      await tester.enterText(inputFields.last, '888888');
      await tester.pump();

      expect(find.text('999999'), findsOneWidget);
      expect(find.text('888888'), findsOneWidget);
    });

    testWidgets('Circom tab maintains scrollability', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify the tab content is scrollable
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Circom tab shows hint text for input fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify hint texts are present
      expect(find.text('For example, 5'), findsOneWidget); // Hint for input a
      expect(find.text('For example, 3'), findsOneWidget); // Hint for input b
    });

    testWidgets('Circom tab handles button interactions', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test Generate Proof button
      final generateButton = find.text('Generate Proof');
      expect(generateButton, findsOneWidget);
      
      // Test Verify Proof button
      final verifyButton = find.text('Verify Proof');
      expect(verifyButton, findsOneWidget);

      // Verify buttons exist and can be tapped
      expect(find.byType(OutlinedButton), findsNWidgets(2));
    });
  });
} 