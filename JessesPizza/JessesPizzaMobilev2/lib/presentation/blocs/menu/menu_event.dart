import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_event.freezed.dart';

@freezed
abstract class MenuEvent with _$MenuEvent {
  const factory MenuEvent.loadMenu() = LoadMenu;
  const factory MenuEvent.checkStoreHours() = CheckStoreHours;
}
