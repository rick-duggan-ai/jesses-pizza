import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';
import 'package:jesses_pizza_app/presentation/screens/account/contact_screen.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState>
    implements MenuBloc {}

void main() {
  late MockMenuBloc menuBloc;

  final storeHours = [
    const StoreHours(day: 0, openingTime: '12:00', closingTime: '20:00'),
    const StoreHours(day: 1, openingTime: '11:00', closingTime: '21:00'),
    const StoreHours(day: 2, openingTime: '11:00', closingTime: '21:00'),
    const StoreHours(day: 3, openingTime: '11:00', closingTime: '21:00'),
    const StoreHours(day: 4, openingTime: '11:00', closingTime: '21:00'),
    const StoreHours(day: 5, openingTime: '11:00', closingTime: '22:00'),
    const StoreHours(day: 6, openingTime: '11:00', closingTime: '22:00'),
  ];

  final loadedState = MenuState.loaded(
    categories: [],
    groups: [],
    isStoreOpen: true,
    settings: StoreSettings(storeHours: storeHours),
  );

  setUp(() {
    menuBloc = MockMenuBloc();
    when(() => menuBloc.state).thenReturn(loadedState);
    whenListen(menuBloc, Stream.value(loadedState),
        initialState: loadedState);
  });

  tearDown(() {
    menuBloc.close();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: menuBloc,
        child: const ContactScreen(),
      ),
    );
  }

  group('ContactScreen', () {
    testWidgets('displays correct phone number', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(find.text('702-898-5635'), findsOneWidget);
    });

    testWidgets('displays correct address', (tester) async {
      await tester.pumpWidget(buildSubject());
      expect(
        find.text('1450 W Horizon Ridge Pkwy #C-201\nHenderson, NV 89012'),
        findsOneWidget,
      );
    });

    testWidgets('displays store hours from API', (tester) async {
      await tester.pumpWidget(buildSubject());

      // Verify day labels are present
      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);
      expect(find.text('Thursday'), findsOneWidget);
      expect(find.text('Friday'), findsOneWidget);
      expect(find.text('Saturday'), findsOneWidget);

      // Verify formatted times
      expect(find.text('12:00 PM - 8:00 PM'), findsOneWidget); // Sunday
      expect(find.text('11:00 AM - 9:00 PM'), findsNWidgets(4)); // Mon-Thu
      expect(find.text('11:00 AM - 10:00 PM'), findsNWidgets(2)); // Fri-Sat
    });

    testWidgets('shows loading indicator when menu is loading',
        (tester) async {
      when(() => menuBloc.state).thenReturn(const MenuState.loading());
      whenListen(menuBloc, Stream.value(const MenuState.loading()),
          initialState: const MenuState.loading());

      await tester.pumpWidget(buildSubject());

      // Phone and address should still be visible (they are static)
      expect(find.text('702-898-5635'), findsOneWidget);
      // Hours section should show a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows fallback message when no hours available',
        (tester) async {
      final noHoursState = MenuState.loaded(
        categories: [],
        groups: [],
        isStoreOpen: true,
        settings: const StoreSettings(),
      );
      when(() => menuBloc.state).thenReturn(noHoursState);
      whenListen(menuBloc, Stream.value(noHoursState),
          initialState: noHoursState);

      await tester.pumpWidget(buildSubject());

      expect(find.text('Hours not available'), findsOneWidget);
    });

    testWidgets('phone number is tappable', (tester) async {
      await tester.pumpWidget(buildSubject());

      // The phone should be wrapped in an InkWell/GestureDetector
      final phoneFinder = find.text('702-898-5635');
      expect(phoneFinder, findsOneWidget);

      // Find the InkWell ancestor of the phone text
      final inkWell = find.ancestor(
        of: phoneFinder,
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);
    });

    testWidgets('address is tappable', (tester) async {
      await tester.pumpWidget(buildSubject());

      final addressFinder =
          find.text('1450 W Horizon Ridge Pkwy #C-201\nHenderson, NV 89012');
      expect(addressFinder, findsOneWidget);

      final inkWell = find.ancestor(
        of: addressFinder,
        matching: find.byType(InkWell),
      );
      expect(inkWell, findsOneWidget);
    });
  });
}
