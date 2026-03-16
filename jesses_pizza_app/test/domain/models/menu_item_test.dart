import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

void main() {
  group('MenuGroup', () {
    test('fromJson creates MenuGroup', () {
      final json = {
        'id': 'group-1',
        'name': 'Pizzas',
        'description': 'Our famous pizzas',
        'imageUrl': 'https://example.com/pizza.jpg',
      };
      final group = MenuGroup.fromJson(json);
      expect(group.name, 'Pizzas');
    });
  });

  group('MenuItem', () {
    test('fromJson creates MenuItem with sizes', () {
      final json = {
        'id': 'item-1',
        'name': 'Pepperoni Pizza',
        'description': 'Classic pepperoni',
        'groupId': 'group-1',
        'imageUrl': 'https://example.com/pepperoni.jpg',
        'sizes': [
          {'name': 'Small', 'price': 9.99},
          {'name': 'Large', 'price': 14.99},
        ],
      };
      final item = MenuItem.fromJson(json);
      expect(item.name, 'Pepperoni Pizza');
      expect(item.sizes.length, 2);
      expect(item.sizes.first.price, 9.99);
    });
  });
}
