import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';
import 'package:jesses_pizza_app/presentation/screens/menu/menu_categories_screen.dart';
import 'package:jesses_pizza_app/presentation/widgets/store_closed_banner.dart';

class MockMenuBloc extends MockBloc<MenuEvent, MenuState> implements MenuBloc {}

void main() {
  late MockMenuBloc mockMenuBloc;

  setUp(() {
    mockMenuBloc = MockMenuBloc();
  });

  tearDown(() {
    mockMenuBloc.close();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<MenuBloc>.value(
        value: mockMenuBloc,
        child: const MenuCategoriesScreen(),
      ),
    );
  }

  group('MenuCategoriesScreen', () {
    testWidgets('shows loading indicator when state is loading', (tester) async {
      when(() => mockMenuBloc.state).thenReturn(const MenuState.loading());

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list of categories when state is loaded', (tester) async {
      final categories = [
        const MenuCategory(id: '1', name: 'Pizzas'),
        const MenuCategory(id: '2', name: 'Drinks'),
      ];

      when(() => mockMenuBloc.state).thenReturn(
        MenuState.loaded(
          categories: categories,
          groups: const <MenuGroup>[],
          isStoreOpen: true,
          settings: const StoreSettings(),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Pizzas'), findsOneWidget);
      expect(find.text('Drinks'), findsOneWidget);
    });

    testWidgets('shows StoreClosedBanner when isStoreOpen is false',
        (tester) async {
      when(() => mockMenuBloc.state).thenReturn(
        MenuState.loaded(
          categories: const <MenuCategory>[],
          groups: const <MenuGroup>[],
          isStoreOpen: false,
          settings: const StoreSettings(),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(StoreClosedBanner), findsOneWidget);
      expect(find.text('Store is currently closed'), findsOneWidget);
    });

    testWidgets('does not show StoreClosedBanner when isStoreOpen is true',
        (tester) async {
      when(() => mockMenuBloc.state).thenReturn(
        MenuState.loaded(
          categories: const <MenuCategory>[],
          groups: const <MenuGroup>[],
          isStoreOpen: true,
          settings: const StoreSettings(),
        ),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.byType(StoreClosedBanner), findsNothing);
    });

    testWidgets('shows error state with retry button on error', (tester) async {
      when(() => mockMenuBloc.state).thenReturn(
        const MenuState.error(message: 'Network error'),
      );

      await tester.pumpWidget(buildSubject());

      expect(find.text('Unable to load menu. Please try again.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
