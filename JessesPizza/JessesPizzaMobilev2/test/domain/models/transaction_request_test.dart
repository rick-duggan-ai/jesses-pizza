import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/domain/models/cart_item.dart';
import 'package:jesses_pizza_app/domain/models/transaction_request.dart';

void main() {
  group('TransactionRequest', () {
    final tCustomerInfo = const CustomerInfo(
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '7025551234',
      emailAddress: 'john@example.com',
      addressLine1: '123 Main St',
      city: 'Henderson',
      zipCode: '89012',
    );

    final tTotals = const OrderTotals(
      subTotal: 25.50,
      taxTotal: 2.04,
      deliveryCharge: 3.00,
      tip: 5.00,
      total: 35.54,
      specialInstructions: 'Ring doorbell',
    );

    final tItems = [
      const TransactionItem(
        menuItemId: 'item-1',
        name: 'Large Pepperoni',
        sizeName: 'Large',
        selectedSizeId: 'size-lg',
        quantity: 1,
        price: 15.99,
        requiredChoicesEnabled: true,
        requiredChoices: 'Pepperoni',
        requiredDelimitedString: 'Pepperoni',
      ),
      const TransactionItem(
        menuItemId: 'item-2',
        name: 'Garlic Bread',
        sizeName: 'Regular',
        quantity: 2,
        price: 4.75,
      ),
    ];

    test('toJson produces expected V1 payload format', () {
      final request = TransactionRequest(
        info: tCustomerInfo,
        transactionItems: tItems,
        totals: tTotals,
        isDelivery: true,
        noContactDelivery: true,
        specialInstructions: 'Ring doorbell',
      );

      // Use jsonEncode/jsonDecode to fully serialize nested objects,
      // matching how Dio serializes the payload for the API.
      final json = jsonDecode(jsonEncode(request.toJson()))
          as Map<String, dynamic>;

      // Verify top-level fields
      expect(json['isDelivery'], true);
      expect(json['noContactDelivery'], true);
      expect(json['specialInstructions'], 'Ring doorbell');

      // Verify customer info
      final info = json['info'] as Map<String, dynamic>;
      expect(info['firstName'], 'John');
      expect(info['lastName'], 'Doe');
      expect(info['phoneNumber'], '7025551234');
      expect(info['emailAddress'], 'john@example.com');
      expect(info['addressLine1'], '123 Main St');
      expect(info['city'], 'Henderson');
      expect(info['zipCode'], '89012');

      // Verify totals
      final totals = json['totals'] as Map<String, dynamic>;
      expect(totals['subTotal'], 25.50);
      expect(totals['taxTotal'], 2.04);
      expect(totals['deliveryCharge'], 3.00);
      expect(totals['tip'], 5.00);
      expect(totals['total'], 35.54);
      expect(totals['specialInstructions'], 'Ring doorbell');

      // Verify items
      final items = json['transactionItems'] as List;
      expect(items.length, 2);
      expect(items[0]['menuItemId'], 'item-1');
      expect(items[0]['name'], 'Large Pepperoni');
      expect(items[0]['requiredChoicesEnabled'], true);
      expect(items[0]['requiredChoices'], 'Pepperoni');
      expect(items[1]['menuItemId'], 'item-2');
      expect(items[1]['quantity'], 2);
    });

    test('fromJson round-trips correctly', () {
      final original = TransactionRequest(
        info: tCustomerInfo,
        transactionItems: tItems,
        totals: tTotals,
        isDelivery: true,
        noContactDelivery: false,
        specialInstructions: 'Leave at door',
        transactionId: 'abc-123',
      );

      // Full round-trip through JSON encoding to ensure nested objects serialize
      final json = jsonDecode(jsonEncode(original.toJson()))
          as Map<String, dynamic>;
      final restored = TransactionRequest.fromJson(json);

      expect(restored.info.firstName, 'John');
      expect(restored.info.lastName, 'Doe');
      expect(restored.transactionItems.length, 2);
      expect(restored.totals.total, 35.54);
      expect(restored.isDelivery, true);
      expect(restored.noContactDelivery, false);
      expect(restored.specialInstructions, 'Leave at door');
      expect(restored.transactionId, 'abc-123');
    });

    test('fromCartState builds request from cart items', () {
      final cartItems = [
        const CartItem(
          menuItemId: 'item-1',
          name: 'Large Pepperoni',
          sizeName: 'Large',
          selectedSizeId: 'size-lg',
          price: 15.99,
          quantity: 1,
          requiredChoicesEnabled: true,
          requiredChoices: 'Pepperoni',
          requiredDelimitedString: 'Pepperoni',
        ),
        const CartItem(
          menuItemId: 'item-2',
          name: 'Garlic Bread',
          sizeName: 'Regular',
          price: 4.75,
          quantity: 2,
        ),
      ];

      final request = TransactionRequest.fromCartState(
        items: cartItems,
        customerInfo: tCustomerInfo,
        totals: tTotals,
        isDelivery: true,
        noContactDelivery: true,
        specialInstructions: 'Extra napkins',
      );

      expect(request.transactionItems.length, 2);
      expect(request.transactionItems[0].menuItemId, 'item-1');
      expect(request.transactionItems[0].requiredChoicesEnabled, true);
      expect(request.transactionItems[0].requiredChoices, 'Pepperoni');
      expect(request.transactionItems[1].menuItemId, 'item-2');
      expect(request.transactionItems[1].quantity, 2);
      expect(request.info.firstName, 'John');
      expect(request.isDelivery, true);
      expect(request.noContactDelivery, true);
      expect(request.specialInstructions, 'Extra napkins');
    });
  });

  group('TransactionItem', () {
    test('toJson serializes all fields including group data', () {
      const item = TransactionItem(
        menuItemId: 'pizza-1',
        name: 'Supreme Pizza',
        description: 'The works',
        sizeName: 'Large',
        selectedSizeId: 'size-lg',
        imageUrl: 'https://example.com/supreme.jpg',
        requiredChoicesEnabled: true,
        requiredChoices: 'Pepperoni,Sausage',
        requiredDelimitedString: 'Pepperoni|Sausage',
        optionalChoicesEnabled: true,
        optionalChoices: 'Extra Cheese',
        optionalDelimitedString: 'Extra Cheese',
        quantity: 1,
        price: 18.99,
        instructionsEnabled: true,
        instructions: 'Well done',
      );

      final json = item.toJson();

      expect(json['menuItemId'], 'pizza-1');
      expect(json['name'], 'Supreme Pizza');
      expect(json['description'], 'The works');
      expect(json['sizeName'], 'Large');
      expect(json['selectedSizeId'], 'size-lg');
      expect(json['imageUrl'], 'https://example.com/supreme.jpg');
      expect(json['requiredChoicesEnabled'], true);
      expect(json['requiredChoices'], 'Pepperoni,Sausage');
      expect(json['requiredDelimitedString'], 'Pepperoni|Sausage');
      expect(json['optionalChoicesEnabled'], true);
      expect(json['optionalChoices'], 'Extra Cheese');
      expect(json['optionalDelimitedString'], 'Extra Cheese');
      expect(json['quantity'], 1);
      expect(json['price'], 18.99);
      expect(json['instructionsEnabled'], true);
      expect(json['instructions'], 'Well done');
    });

    test('fromCartItem converts CartItem correctly', () {
      const cartItem = CartItem(
        menuItemId: 'item-1',
        name: 'Cheese Pizza',
        description: 'Classic cheese',
        sizeName: 'Medium',
        selectedSizeId: 'size-md',
        price: 12.99,
        quantity: 2,
        imageUrl: 'https://example.com/cheese.jpg',
        requiredChoicesEnabled: true,
        requiredChoices: 'Mozzarella',
        requiredDelimitedString: 'Mozzarella',
        optionalChoicesEnabled: false,
        instructionsEnabled: true,
        instructions: 'Light sauce',
      );

      final txItem = TransactionItem.fromCartItem(cartItem);

      expect(txItem.menuItemId, 'item-1');
      expect(txItem.name, 'Cheese Pizza');
      expect(txItem.description, 'Classic cheese');
      expect(txItem.sizeName, 'Medium');
      expect(txItem.selectedSizeId, 'size-md');
      expect(txItem.price, 12.99);
      expect(txItem.quantity, 2);
      expect(txItem.imageUrl, 'https://example.com/cheese.jpg');
      expect(txItem.requiredChoicesEnabled, true);
      expect(txItem.requiredChoices, 'Mozzarella');
      expect(txItem.optionalChoicesEnabled, false);
      expect(txItem.instructionsEnabled, true);
      expect(txItem.instructions, 'Light sauce');
    });
  });

  group('PostTransactionRequest', () {
    test('toJson wraps transaction and card correctly', () {
      final request = PostTransactionRequest(
        transaction: TransactionRequest(
          info: const CustomerInfo(
            firstName: 'Jane',
            lastName: 'Smith',
            phoneNumber: '7025559999',
            emailAddress: 'jane@example.com',
          ),
          transactionItems: const [],
          totals: const OrderTotals(total: 10.00, subTotal: 10.00),
          isDelivery: false,
        ),
        card: const CreditCardRef(id: 'card-123'),
      );

      // Full serialization as Dio would do it
      final json = jsonDecode(jsonEncode(request.toJson()))
          as Map<String, dynamic>;
      expect(json['transaction'], isA<Map>());
      expect(json['card'], isA<Map>());
      expect((json['card'] as Map)['id'], 'card-123');
      expect(
        (json['transaction'] as Map)['isDelivery'],
        false,
      );
    });
  });

  group('OrderTotals', () {
    test('toJson serializes all fields', () {
      const totals = OrderTotals(
        subTotal: 20.00,
        taxTotal: 1.60,
        deliveryCharge: 3.50,
        tip: 4.00,
        total: 29.10,
        specialInstructions: 'No onions',
      );

      final json = totals.toJson();
      expect(json['subTotal'], 20.00);
      expect(json['taxTotal'], 1.60);
      expect(json['deliveryCharge'], 3.50);
      expect(json['tip'], 4.00);
      expect(json['total'], 29.10);
      expect(json['specialInstructions'], 'No onions');
    });

    test('defaults are applied correctly', () {
      const totals = OrderTotals();
      expect(totals.taxTotal, 0);
      expect(totals.deliveryCharge, 0);
      expect(totals.subTotal, 0);
      expect(totals.total, 0);
      expect(totals.tip, 0);
      expect(totals.specialInstructions, isNull);
    });
  });
}
