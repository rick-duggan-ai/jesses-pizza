import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/presentation/screens/account/about_screen.dart';

void main() {
  Widget buildSubject() {
    return const MaterialApp(
      home: AboutScreen(),
    );
  }

  group('AboutScreen', () {
    testWidgets('has About app bar title', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('displays Jesse\'s Pizza heading', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text("Jesse's Pizza"), findsOneWidget);
    });

    testWidgets('contains history about Jesse bringing family to Las Vegas',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.textContaining(
            'Jesse brought his family to Las Vegas in 1946'),
        findsOneWidget,
      );
    });

    testWidgets('contains history about Mina Mansion', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.textContaining('Mina Mansion'),
        findsOneWidget,
      );
    });

    testWidgets('contains history about Jack and his two sons',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.textContaining('Jack and his two sons'),
        findsOneWidget,
      );
    });

    testWidgets('contains information about scratch-made menu items',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.textContaining('items made from scratch'),
        findsOneWidget,
      );
    });

    testWidgets('contains the secret ingredient revelation', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(
        find.textContaining('the one secret ingredient'),
        findsOneWidget,
      );
    });

    testWidgets('displays Our Story section heading', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Our Story'), findsOneWidget);
    });

    testWidgets('displays Our Food section heading', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Our Food'), findsOneWidget);
    });
  });
}
