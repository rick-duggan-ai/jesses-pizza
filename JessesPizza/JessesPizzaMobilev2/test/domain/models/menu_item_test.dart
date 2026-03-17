import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/menu_category.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

void main() {
  group('MenuGroup', () {
    test('fromJson creates MenuGroup with Groups endpoint shape', () {
      final json = {
        'id': '8A6BE945D2B908DBDDB04CD3',
        'name': 'Dipping Sauces Included',
        'type': 0,
        'groupType': 1,
        'isRequired': true,
        'min': 0,
        'max': 0,
        'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/8A6BE945D2B908DBDDB04CD3.jpg',
        'items': [
          {
            'id': '4E0A6C34205FB4EF7F8A9AD9',
            'groupId': '8A6BE945D2B908DBDDB04CD3',
            'name': 'Bleu Cheese',
            'imageUrl': null,
            'sizes': [],
            'sides': [],
          }
        ],
      };
      final group = MenuGroup.fromJson(json);
      expect(group.name, 'Dipping Sauces Included');
      expect(group.isRequired, true);
      expect(group.items.length, 1);
      expect(group.items.first.name, 'Bleu Cheese');
    });
  });

  group('MenuItem', () {
    test('fromJson creates MenuItem with actual API shape', () {
      final json = {
        'id': '6c84287c33277b20d0865b21',
        'name': r'$20 MEAL DEAL',
        'description': 'Large (16") Cheese Pizza, 6 Garlic Knots and a 2 Liter of Soda!',
        'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/6c84287c33277b20d0865b21.jpg',
        'sizes': [
          {
            'id': '03067C5CF42C5F4132E1E2F9',
            'name': r'$20 MEAL',
            'price': 20.0,
            'isDefault': false,
            'groupIds': ['686D4DF22587FCDF8F05A9CB', '327C782A077B68FE9928FB82'],
          }
        ],
      };
      final item = MenuItem.fromJson(json);
      expect(item.name, r'$20 MEAL DEAL');
      expect(item.sizes.length, 1);
      expect(item.sizes.first.price, 20.0);
      expect(item.sizes.first.groupIds.length, 2);
    });
  });

  group('MenuCategory', () {
    test('fromJson creates MenuCategory with nested menuItems', () {
      final json = {
        'id': '5942c256617419278227f197',
        'name': r'$20 MEAL DEAL',
        'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/5942c256617419278227f197.jpg',
        'ordinal': 0,
        'menuItems': [
          {
            'id': '6c84287c33277b20d0865b21',
            'name': r'$20 MEAL DEAL',
            'imageUrl': 'https://services.jessespizza.com:5001/JessesImages/6c84287c33277b20d0865b21.jpg',
            'description': 'Large (16") Cheese Pizza, 6 Garlic Knots and a 2 Liter of Soda!',
            'sizes': [
              {
                'id': '03067C5CF42C5F4132E1E2F9',
                'name': r'$20 MEAL',
                'price': 20.0,
                'isDefault': false,
                'groupIds': ['686D4DF22587FCDF8F05A9CB'],
              }
            ],
          }
        ],
      };
      final category = MenuCategory.fromJson(json);
      expect(category.name, r'$20 MEAL DEAL');
      expect(category.ordinal, 0);
      expect(category.menuItems.length, 1);
      expect(category.menuItems.first.sizes.first.price, 20.0);
    });
  });
}
