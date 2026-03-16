import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/transaction.dart';
import 'package:jesses_pizza_app/domain/models/address.dart';
import 'package:jesses_pizza_app/domain/models/credit_card.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';

void main() {
  group('Transaction', () {
    test('fromJson creates Transaction from v1.1 response', () {
      final json = {
        'id': 'txn-1',
        'date': '2026-03-16T12:00:00Z',
        'total': 24.99,
        'isDelivery': true,
        'name': 'John Doe',
        'transactionState': 'Authorized',
        'items': [],
      };
      final txn = Transaction.fromJson(json);
      expect(txn.total, 24.99);
      expect(txn.isDelivery, true);
    });
  });

  group('Address', () {
    test('fromJson creates Address', () {
      final json = {
        'id': 'addr-1',
        'addressLine1': '123 Main St',
        'city': 'Springfield',
        'zipCode': '12345',
      };
      final addr = Address.fromJson(json);
      expect(addr.addressLine1, '123 Main St');
    });
  });

  group('CreditCard', () {
    test('fromJson creates CreditCard with masked number', () {
      final json = {
        'id': 'card-1',
        'cardNumber': '****1234',
        'expirationDate': '12/28',
      };
      final card = CreditCard.fromJson(json);
      expect(card.cardNumber, '****1234');
    });
  });

  group('CartItem', () {
    test('calculates line total from quantity and price', () {
      final item = CartItem(
        menuItemId: 'item-1',
        name: 'Pepperoni Pizza',
        sizeName: 'Large',
        price: 14.99,
        quantity: 2,
      );
      expect(item.lineTotal, 29.98);
    });
  });
}
