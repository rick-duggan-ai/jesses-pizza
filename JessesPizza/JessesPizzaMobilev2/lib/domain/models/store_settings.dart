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

  /// Returns true if the store is currently open based on storeHours.
  /// The API's DayOfTheWeek enum is Monday=0 .. Sunday=6.
  /// Dart's DateTime.weekday is Monday=1 .. Sunday=7, so we subtract 1.
  /// Times are evaluated in Pacific Time (where the store is located).
  bool isOpen() {
    if (storeHours.isEmpty) return false;
    final now = _nowInPacific();
    final todayIndex = now.weekday - 1;
    final todayHours = storeHours.where((h) => h.day == todayIndex).firstOrNull;
    if (todayHours == null) return false;
    final openMinutes = _parseTimeMinutes(todayHours.openingTime);
    final closeMinutes = _parseTimeMinutes(todayHours.closingTime);
    if (openMinutes == null || closeMinutes == null) return false;
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  }

  /// Returns today's store hours in Pacific Time, or null if none configured.
  StoreHours? todayHours() {
    if (storeHours.isEmpty) return null;
    final todayIndex = _nowInPacific().weekday - 1;
    return storeHours.where((h) => h.day == todayIndex).firstOrNull;
  }
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

/// Returns the current time in US Pacific (PST/PDT).
/// PST = UTC-8, PDT = UTC-7 (second Sunday of March → first Sunday of November).
DateTime _nowInPacific() {
  final utc = DateTime.now().toUtc();
  final year = utc.year;
  // Spring forward: 2am PST on second Sunday of March = 10:00 UTC
  final dstStart = DateTime.utc(year, 3, _nthSundayOfMonth(year, 3, 2), 10);
  // Fall back: 2am PDT on first Sunday of November = 09:00 UTC
  final dstEnd = DateTime.utc(year, 11, _nthSundayOfMonth(year, 11, 1), 9);
  final isPDT = utc.isAfter(dstStart) && utc.isBefore(dstEnd);
  return utc.add(Duration(hours: isPDT ? -7 : -8));
}

/// Returns the day-of-month for the nth Sunday of the given month/year.
int _nthSundayOfMonth(int year, int month, int n) {
  final firstOfMonth = DateTime.utc(year, month, 1);
  // Dart weekday: Mon=1 .. Sun=7. Days until next Sunday: (7 - weekday) % 7.
  final daysToFirstSunday = (7 - firstOfMonth.weekday) % 7;
  return 1 + daysToFirstSunday + (n - 1) * 7;
}

/// Parses a time string (ISO 8601 or "HH:mm[:ss]") into minutes since midnight.
int? _parseTimeMinutes(String? timeStr) {
  if (timeStr == null || timeStr.isEmpty) return null;
  final dt = DateTime.tryParse(timeStr);
  if (dt != null) return dt.hour * 60 + dt.minute;
  final parts = timeStr.split(':');
  if (parts.length >= 2) {
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h != null && m != null) return h * 60 + m;
  }
  return null;
}

@freezed
abstract class ZipCode with _$ZipCode {
  const factory ZipCode({
    String? zipCodeValue,
  }) = _ZipCode;

  factory ZipCode.fromJson(Map<String, dynamic> json) =>
      _$ZipCodeFromJson(json);
}
