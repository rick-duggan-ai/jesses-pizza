import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_settings.freezed.dart';
part 'store_settings.g.dart';

@freezed
abstract class StoreSettings with _$StoreSettings {
  const StoreSettings._();

  const factory StoreSettings({
    String? id,
    @Default(8.0) double taxRate,
    @Default(3.99) double deliveryCharge,
    @Default(0.0) double minimumOrderAmount,
    @Default([]) List<StoreHours> storeHours,
    @Default([]) List<ZipCode> zipCodes,
    String? aboutText,
  }) = _StoreSettings;

  factory StoreSettings.fromJson(Map<String, dynamic> json) =>
      _$StoreSettingsFromJson(json);

  /// Fallback defaults used until settings are loaded from the API.
  static const StoreSettings defaults = StoreSettings();
}

@freezed
abstract class StoreHours with _$StoreHours {
  const factory StoreHours({
    @Default(0) int day,
    String? openingTime,
    String? closingTime,
  }) = _StoreHours;

  factory StoreHours.fromJson(Map<String, dynamic> json) =>
      _$StoreHoursFromJson(json);
}

@freezed
abstract class ZipCode with _$ZipCode {
  const factory ZipCode({
    String? zipCodeValue,
  }) = _ZipCode;

  factory ZipCode.fromJson(Map<String, dynamic> json) =>
      _$ZipCodeFromJson(json);
}
