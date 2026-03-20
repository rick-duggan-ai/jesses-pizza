import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/store_settings.dart';

void main() {
  group('StoreSettings', () {
    test('fromJson creates StoreSettings with all fields', () {
      final json = {
        'id': '507f1f77bcf86cd799439011',
        'taxRate': 8.0,
        'deliveryCharge': 3.99,
        'minimumOrderAmount': 15.0,
        'storeHours': [
          {
            'day': 0,
            'openingTime': '2026-01-01T11:00:00Z',
            'closingTime': '2026-01-01T22:00:00Z',
          },
          {
            'day': 1,
            'openingTime': '2026-01-01T11:00:00Z',
            'closingTime': '2026-01-01T22:00:00Z',
          },
        ],
        'zipCodes': [
          {'zipCodeValue': '08701'},
          {'zipCodeValue': '08723'},
        ],
        'aboutText': 'Best pizza in town!',
      };

      final settings = StoreSettings.fromJson(json);

      expect(settings.id, '507f1f77bcf86cd799439011');
      expect(settings.taxRate, 8.0);
      expect(settings.deliveryCharge, 3.99);
      expect(settings.minimumOrderAmount, 15.0);
      expect(settings.storeHours.length, 2);
      expect(settings.storeHours.first.day, 0);
      expect(settings.storeHours.first.openingTime, '2026-01-01T11:00:00Z');
      expect(settings.storeHours.first.closingTime, '2026-01-01T22:00:00Z');
      expect(settings.zipCodes.length, 2);
      expect(settings.zipCodes.first.zipCodeValue, '08701');
      expect(settings.aboutText, 'Best pizza in town!');
    });

    test('fromJson uses defaults for missing optional fields', () {
      final json = <String, dynamic>{};

      final settings = StoreSettings.fromJson(json);

      expect(settings.id, isNull);
      expect(settings.taxRate, 8.0);
      expect(settings.deliveryCharge, 3.99);
      expect(settings.minimumOrderAmount, 0.0);
      expect(settings.storeHours, isEmpty);
      expect(settings.zipCodes, isEmpty);
      expect(settings.aboutText, isNull);
    });

    test('defaults static constant has expected values', () {
      expect(StoreSettings.defaults.taxRate, 8.0);
      expect(StoreSettings.defaults.deliveryCharge, 3.99);
      expect(StoreSettings.defaults.minimumOrderAmount, 0.0);
      expect(StoreSettings.defaults.storeHours, isEmpty);
      expect(StoreSettings.defaults.zipCodes, isEmpty);
    });

    test('toJson roundtrips correctly', () {
      final original = StoreSettings(
        id: 'abc123',
        taxRate: 7.5,
        deliveryCharge: 4.99,
        minimumOrderAmount: 20.0,
        storeHours: [
          StoreHours(day: 0, openingTime: '11:00', closingTime: '22:00'),
        ],
        zipCodes: [ZipCode(zipCodeValue: '08701')],
        aboutText: 'Hello',
      );

      final json = original.toJson();
      final restored = StoreSettings.fromJson(json);

      expect(restored, original);
    });
  });

  group('StoreHours', () {
    test('fromJson creates StoreHours', () {
      final json = {
        'day': 5,
        'openingTime': '2026-01-01T10:00:00Z',
        'closingTime': '2026-01-01T23:00:00Z',
      };

      final hours = StoreHours.fromJson(json);

      expect(hours.day, 5);
      expect(hours.openingTime, '2026-01-01T10:00:00Z');
      expect(hours.closingTime, '2026-01-01T23:00:00Z');
    });

    test('fromJson handles null times', () {
      final json = {'day': 6};

      final hours = StoreHours.fromJson(json);

      expect(hours.day, 6);
      expect(hours.openingTime, isNull);
      expect(hours.closingTime, isNull);
    });
  });

  group('ZipCode', () {
    test('fromJson creates ZipCode', () {
      final json = {'zipCodeValue': '08701'};

      final zipCode = ZipCode.fromJson(json);

      expect(zipCode.zipCodeValue, '08701');
    });
  });
}
