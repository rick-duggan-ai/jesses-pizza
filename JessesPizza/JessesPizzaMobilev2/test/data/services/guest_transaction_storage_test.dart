import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jesses_pizza_app/data/services/guest_transaction_storage.dart';

void main() {
  late GuestTransactionStorage storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = GuestTransactionStorage(prefs: prefs);
  });

  group('GuestTransactionStorage', () {
    test('getGuids returns empty list when nothing stored', () {
      expect(storage.getGuids(), isEmpty);
    });

    test('addGuid stores a GUID', () async {
      await storage.addGuid('guid-1');
      expect(storage.getGuids(), ['guid-1']);
    });

    test('addGuid prepends newest first', () async {
      await storage.addGuid('guid-1');
      await storage.addGuid('guid-2');
      expect(storage.getGuids(), ['guid-2', 'guid-1']);
    });

    test('addGuid skips duplicates', () async {
      await storage.addGuid('guid-1');
      await storage.addGuid('guid-1');
      expect(storage.getGuids(), ['guid-1']);
    });

    test('removeGuid removes a specific GUID', () async {
      await storage.addGuid('guid-1');
      await storage.addGuid('guid-2');
      await storage.removeGuid('guid-1');
      expect(storage.getGuids(), ['guid-2']);
    });

    test('clear removes all GUIDs', () async {
      await storage.addGuid('guid-1');
      await storage.addGuid('guid-2');
      await storage.clear();
      expect(storage.getGuids(), isEmpty);
    });
  });
}
