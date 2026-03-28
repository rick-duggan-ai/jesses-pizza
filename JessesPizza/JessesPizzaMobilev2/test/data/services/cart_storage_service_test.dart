import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jesses_pizza_app/data/services/cart_storage_service.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

void main() {
  const tItem1 = CartItem(
    menuItemId: 'item-1',
    name: 'Pepperoni Pizza',
    sizeName: 'Large',
    price: 14.99,
    quantity: 1,
  );

  const tItem2 = CartItem(
    menuItemId: 'item-2',
    name: 'Cheese Pizza',
    sizeName: 'Medium',
    price: 11.99,
    quantity: 2,
    specialInstructions: 'Extra cheese',
  );

  late CartStorageService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    service = CartStorageService(prefs);
  });

  group('CartStorageService', () {
    test('load returns empty list when nothing is stored', () {
      final items = service.load();
      expect(items, isEmpty);
    });

    test('save persists cart items and load restores them', () async {
      await service.save([tItem1, tItem2]);

      final loaded = service.load();
      expect(loaded, hasLength(2));
      expect(loaded[0].menuItemId, 'item-1');
      expect(loaded[0].name, 'Pepperoni Pizza');
      expect(loaded[0].sizeName, 'Large');
      expect(loaded[0].price, 14.99);
      expect(loaded[0].quantity, 1);
      expect(loaded[1].menuItemId, 'item-2');
      expect(loaded[1].name, 'Cheese Pizza');
      expect(loaded[1].specialInstructions, 'Extra cheese');
      expect(loaded[1].quantity, 2);
    });

    test('save with empty list stores empty array', () async {
      // First save some items
      await service.save([tItem1]);
      expect(service.load(), hasLength(1));

      // Now save empty list
      await service.save([]);
      final loaded = service.load();
      expect(loaded, isEmpty);
    });

    test('clear removes persisted cart data', () async {
      await service.save([tItem1, tItem2]);
      expect(service.load(), hasLength(2));

      await service.clear();
      expect(service.load(), isEmpty);
    });

    test('load returns empty list on corrupted data', () async {
      // Manually write bad data
      SharedPreferences.setMockInitialValues({'cart_items': 'not-json{'});
      final prefs = await SharedPreferences.getInstance();
      final badService = CartStorageService(prefs);

      final loaded = badService.load();
      expect(loaded, isEmpty);
    });

    test('round-trip preserves all CartItem fields', () async {
      const fullItem = CartItem(
        menuItemId: 'full-1',
        name: 'Supreme Pizza',
        description: 'The works',
        sizeName: 'XL',
        selectedSizeId: 'size-xl',
        imageUrl: 'https://example.com/supreme.jpg',
        price: 19.99,
        quantity: 3,
        specialInstructions: 'Cut in squares',
        requiredChoicesEnabled: true,
        requiredChoices: 'Crust: Thin',
        requiredDelimitedString: 'thin',
        optionalChoicesEnabled: true,
        optionalChoices: 'Extra sauce',
        optionalDelimitedString: 'extra-sauce',
        instructionsEnabled: true,
        instructions: 'Ring doorbell',
      );

      await service.save([fullItem]);
      final loaded = service.load();
      expect(loaded, hasLength(1));

      final restored = loaded.first;
      expect(restored.menuItemId, fullItem.menuItemId);
      expect(restored.name, fullItem.name);
      expect(restored.description, fullItem.description);
      expect(restored.sizeName, fullItem.sizeName);
      expect(restored.selectedSizeId, fullItem.selectedSizeId);
      expect(restored.imageUrl, fullItem.imageUrl);
      expect(restored.price, fullItem.price);
      expect(restored.quantity, fullItem.quantity);
      expect(restored.specialInstructions, fullItem.specialInstructions);
      expect(restored.requiredChoicesEnabled, fullItem.requiredChoicesEnabled);
      expect(restored.requiredChoices, fullItem.requiredChoices);
      expect(restored.requiredDelimitedString, fullItem.requiredDelimitedString);
      expect(restored.optionalChoicesEnabled, fullItem.optionalChoicesEnabled);
      expect(restored.optionalChoices, fullItem.optionalChoices);
      expect(restored.optionalDelimitedString, fullItem.optionalDelimitedString);
      expect(restored.instructionsEnabled, fullItem.instructionsEnabled);
      expect(restored.instructions, fullItem.instructions);
    });
  });
}
