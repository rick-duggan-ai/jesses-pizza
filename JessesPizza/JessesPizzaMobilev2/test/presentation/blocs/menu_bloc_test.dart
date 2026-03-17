import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_bloc.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_event.dart';
import 'package:jesses_pizza_app/presentation/blocs/menu/menu_state.dart';

class MockMenuRepository extends Mock implements IMenuRepository {}

void main() {
  late MockMenuRepository mockRepo;

  final tGroups = <MenuGroup>[];
  final tItems = <MenuItem>[];

  setUp(() {
    mockRepo = MockMenuRepository();
  });

  group('MenuBloc', () {
    test('initial state is MenuInitial', () {
      final bloc = MenuBloc(repository: mockRepo);
      expect(bloc.state, const MenuState.initial());
      bloc.close();
    });

    blocTest<MenuBloc, MenuState>(
      'emits [loading, loaded] on LoadMenu success',
      build: () {
        when(() => mockRepo.getGroups()).thenAnswer((_) async => tGroups);
        when(() => mockRepo.getMenuItems()).thenAnswer((_) async => tItems);
        when(() => mockRepo.checkHours()).thenAnswer((_) async => true);
        return MenuBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const MenuEvent.loadMenu()),
      expect: () => [
        const MenuState.loading(),
        MenuState.loaded(groups: tGroups, items: tItems, isStoreOpen: true),
      ],
    );

    blocTest<MenuBloc, MenuState>(
      'emits [loading, error] on LoadMenu failure',
      build: () {
        when(() => mockRepo.getGroups()).thenThrow(Exception('Network error'));
        when(() => mockRepo.getMenuItems()).thenAnswer((_) async => tItems);
        when(() => mockRepo.checkHours()).thenAnswer((_) async => false);
        return MenuBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const MenuEvent.loadMenu()),
      expect: () => [
        const MenuState.loading(),
        isA<MenuError>(),
      ],
    );
  });
}
