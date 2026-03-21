import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest_info.freezed.dart';
part 'guest_info.g.dart';

@freezed
abstract class GuestInfo with _$GuestInfo {
  const factory GuestInfo({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String addressLine1,
    required String city,
    required String zipCode,
  }) = _GuestInfo;

  factory GuestInfo.fromJson(Map<String, dynamic> json) =>
      _$GuestInfoFromJson(json);
}
