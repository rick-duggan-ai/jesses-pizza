import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';
import 'package:jesses_pizza_app/domain/repositories/i_menu_repository.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final IMenuRepository _repo;

  MenuBloc({required IMenuRepository repository})
      : _repo = repository,
        super(const MenuState.initial()) {
    on<LoadMenu>(_onLoadMenu);
    on<CheckStoreHours>(_onCheckStoreHours);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    emit(const MenuState.loading());
    try {
      final results = await Future.wait([
        _repo.getMenuItems(),
        _repo.getGroups(),
        _repo.checkHours(),
        _repo.getSettings(),
      ]);
      final categories = results[0] as List<MenuCategory>;
      final groups = results[1] as List<MenuGroup>;
      final isStoreOpen = results[2] as bool;
      final settings = results[3] as StoreSettings;
      emit(MenuState.loaded(
        categories: categories,
        groups: groups,
        isStoreOpen: isStoreOpen,
        settings: settings,
      ));
    } catch (e) {
      emit(MenuState.error(message: e.toString()));
    }
  }

  Future<void> _onCheckStoreHours(
      CheckStoreHours event, Emitter<MenuState> emit) async {
    try {
      final isOpen = await _repo.checkHours();
      final current = state;
      if (current is MenuLoaded) {
        emit(current.copyWith(isStoreOpen: isOpen));
      }
    } catch (e) {
      emit(MenuState.error(message: e.toString()));
    }
  }
}
