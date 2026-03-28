import 'package:flutter_test/flutter_test.dart';
import 'package:jesses_pizza_app/data/services/signalr_service.dart';

void main() {
  group('SignalRService', () {
    late SignalRService service;

    setUp(() {
      service = SignalRService(baseUrl: 'https://example.com');
    });

    tearDown(() async {
      await service.dispose();
    });

    test('initial state is not connected', () {
      expect(service.isConnected, isFalse);
    });

    test('paymentResults stream emits events', () async {
      // Verify the stream is a broadcast stream that can be listened to
      // without an active connection.
      final events = <HppPaymentEvent>[];
      final subscription = service.paymentResults.listen(events.add);
      // No events should be emitted without a connection
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(events, isEmpty);
      await subscription.cancel();
    });

    test('disconnect is safe to call without prior connect', () async {
      // Should not throw
      await service.disconnect();
      expect(service.isConnected, isFalse);
    });

    test('dispose is safe to call without prior connect', () async {
      // Should not throw
      await service.dispose();
    });
  });

  group('HppPaymentEvent', () {
    test('creates with required fields', () {
      const event = HppPaymentEvent(
        result: HppPaymentResult.approve,
        transactionGuid: 'abc-123',
      );
      expect(event.result, HppPaymentResult.approve);
      expect(event.transactionGuid, 'abc-123');
      expect(event.message, isNull);
      expect(event.data, isNull);
    });

    test('creates with optional message', () {
      const event = HppPaymentEvent(
        result: HppPaymentResult.decline,
        transactionGuid: 'abc-123',
        message: 'Card was declined',
      );
      expect(event.result, HppPaymentResult.decline);
      expect(event.message, 'Card was declined');
    });

    test('creates with optional data', () {
      const event = HppPaymentEvent(
        result: HppPaymentResult.approve,
        transactionGuid: 'abc-123',
        data: {'isGuest': true},
      );
      expect(event.data, {'isGuest': true});
    });
  });

  group('HppPaymentResult', () {
    test('has all expected values', () {
      expect(HppPaymentResult.values, containsAll([
        HppPaymentResult.approve,
        HppPaymentResult.decline,
        HppPaymentResult.cancel,
        HppPaymentResult.failed,
      ]));
      expect(HppPaymentResult.values.length, 4);
    });
  });
}
