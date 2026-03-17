import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_group.freezed.dart';
part 'menu_group.g.dart';

@freezed
abstract class MenuGroup with _$MenuGroup {
  const factory MenuGroup({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  }) = _MenuGroup;

  factory MenuGroup.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupFromJson(json);
}
