import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/data/services/signalr_service.dart';
import 'package:jesses_pizza_app/presentation/screens/cart/hpp_webview_screen.dart';

void main() {
  group('HppResult', () {
    test('creates with approve result and no data', () {
      const result = HppResult(paymentResult: HppPaymentResult.approve);
      expect(result.paymentResult, HppPaymentResult.approve);
      expect(result.data, isNull);
      expect(result.message, isNull);
    });

    test('creates with approve result and card data', () {
      const result = HppResult(
        paymentResult: HppPaymentResult.approve,
        data: {
          'IsGuest': false,
          'IsCardSaved': false,
          'Card': {
            'id': 'card-123',
            'cardNumber': '****1234',
            'expirationDate': '1225',
          },
        },
      );
      expect(result.paymentResult, HppPaymentResult.approve);
      expect(result.data?['IsCardSaved'], false);
      expect(result.data?['Card'], isA<Map<String, dynamic>>());
      final card = result.data!['Card'] as Map<String, dynamic>;
      expect(card['cardNumber'], '****1234');
    });

    test('IsCardSaved true means card is already saved', () {
      const result = HppResult(
        paymentResult: HppPaymentResult.approve,
        data: {
          'IsGuest': false,
          'IsCardSaved': true,
          'Card': {
            'id': 'card-123',
            'cardNumber': '****1234',
            'expirationDate': '1225',
          },
        },
      );
      final isCardSaved = result.data?['IsCardSaved'] as bool? ?? false;
      expect(isCardSaved, isTrue);
    });

    test('missing data means no card to save', () {
      const result = HppResult(paymentResult: HppPaymentResult.approve);
      final cardData = result.data?['Card'] as Map<String, dynamic>?;
      expect(cardData, isNull);
    });

    test('creates with decline result and message', () {
      const result = HppResult(
        paymentResult: HppPaymentResult.decline,
        message: 'Card was declined',
      );
      expect(result.paymentResult, HppPaymentResult.decline);
      expect(result.message, 'Card was declined');
    });

    test('creates with cancel result', () {
      const result = HppResult(paymentResult: HppPaymentResult.cancel);
      expect(result.paymentResult, HppPaymentResult.cancel);
    });

    test('creates with failed result', () {
      const result = HppResult(
        paymentResult: HppPaymentResult.failed,
        message: 'Something went wrong',
      );
      expect(result.paymentResult, HppPaymentResult.failed);
      expect(result.message, 'Something went wrong');
    });
  });
}
