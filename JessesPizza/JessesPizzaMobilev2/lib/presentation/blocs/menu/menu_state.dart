import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

part 'menu_state.freezed.dart';

@freezed
abstract class MenuState with _$MenuState {
  const factory MenuState.initial() = MenuInitial;
  const factory MenuState.loading() = MenuLoading;
  const factory MenuState.loaded({
    required List<MenuGroup> groups,
    required List<MenuItem> items,
    required bool isStoreOpen,
  }) = MenuLoaded;
  const factory MenuState.error({required String message}) = MenuError;
}
