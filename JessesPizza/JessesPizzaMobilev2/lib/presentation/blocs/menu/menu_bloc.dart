import 'package:flutter_bloc/flutter_bloc.dart';
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
      final groups = await _repo.getGroups();
      final items = await _repo.getMenuItems();
      final isStoreOpen = await _repo.checkHours();
      emit(MenuState.loaded(
        groups: groups,
        items: items,
        isStoreOpen: isStoreOpen,
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
