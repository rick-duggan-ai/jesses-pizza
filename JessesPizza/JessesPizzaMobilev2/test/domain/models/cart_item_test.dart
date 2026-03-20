import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/group_selection.dart';
import 'package:jesses_pizza_app/domain/models/menu_group.dart';
import 'package:jesses_pizza_app/domain/models/menu_item.dart';

void main() {
  group('CartItem', () {
    test('totalPrice equals base price when no group items', () {
      const item = CartItem(menuItemId: '1', name: 'Pizza', sizeName: 'Large', price: 12.99, quantity: 1);
      expect(item.totalPrice, 12.99);
    });
    test('totalPrice includes group item extras', () {
      final gi = SelectedGroupItem(groupItem: const MenuGroupItem(id: 'g1', name: 'Extra Cheese', sizes: [MenuItemSize(name: 'Regular', price: 1.50, isDefault: true)]));
      final item = CartItem(menuItemId: '1', name: 'Pizza', sizeName: 'Large', price: 12.99, quantity: 1, selectedGroupItems: [gi]);
      expect(item.totalPrice, closeTo(14.49, 0.01));
    });
    test('lineTotal multiplies totalPrice by quantity', () {
      final gi = SelectedGroupItem(groupItem: const MenuGroupItem(id: 'g1', name: 'Pepperoni', sizes: [MenuItemSize(name: 'Regular', price: 2.00, isDefault: true)]));
      final item = CartItem(menuItemId: '1', name: 'Pizza', sizeName: 'Large', price: 10.00, quantity: 3, selectedGroupItems: [gi]);
      expect(item.lineTotal, closeTo(36.0, 0.01));
    });
    test('selectionsDescription formats selected items', () {
      final i1 = SelectedGroupItem(groupItem: const MenuGroupItem(id: 'g1', name: 'Pepperoni', sizes: [MenuItemSize(name: 'Regular', price: 0)]));
      final i2 = SelectedGroupItem(groupItem: const MenuGroupItem(id: 'g2', name: 'Mushrooms', sizes: [MenuItemSize(name: 'Regular', price: 0, isDefault: true), MenuItemSize(name: 'Extra', price: 1.0)]), sizeIndex: 1);
      final ci = CartItem(menuItemId: '1', name: 'Pizza', sizeName: 'Large', price: 10.00, quantity: 1, selectedGroupItems: [i1, i2]);
      expect(ci.selectionsDescription, contains('Pepperoni'));
      expect(ci.selectionsDescription, contains('Mushrooms'));
    });
    test('copyWith preserves selectedGroupItems', () {
      final gi = SelectedGroupItem(groupItem: const MenuGroupItem(id: 'g1', name: 'Cheese', sizes: [MenuItemSize(name: 'Regular', price: 1.0, isDefault: true)]));
      final item = CartItem(menuItemId: '1', name: 'Pizza', sizeName: 'Large', price: 10.00, quantity: 1, selectedGroupItems: [gi], specialInstructions: 'No onions');
      final updated = item.copyWith(quantity: 2);
      expect(updated.quantity, 2); expect(updated.selectedGroupItems.length, 1); expect(updated.specialInstructions, 'No onions');
    });
  });
}
