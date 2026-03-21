import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';

part 'menu_state.freezed.dart';

@freezed
abstract class MenuState with _$MenuState {
  const factory MenuState.initial() = MenuInitial;
  const factory MenuState.loading() = MenuLoading;
  const factory MenuState.loaded({
    required List<MenuCategory> categories,
    required List<MenuGroup> groups,
    required bool isStoreOpen,
  }) = MenuLoaded;
  const factory MenuState.error({required String message}) = MenuError;
}
