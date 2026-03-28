import 'dart:async';
import 'package:logging/logging.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// The result type received from the HPP payment hub.
enum HppPaymentResult { approve, decline, cancel, failed }

/// Encapsulates an HPP payment event received via SignalR.
class HppPaymentEvent {
  final HppPaymentResult result;
  final String transactionGuid;
  final String? message;
  final Map<String, dynamic>? data;

  const HppPaymentEvent({
    required this.result,
    required this.transactionGuid,
    this.message,
    this.data,
  });
}

/// Service that manages a SignalR connection to the PizzaHub for real-time
/// HPP payment result notifications.
///
/// Mirrors the V1 Xamarin implementation in WebViewPage.xaml.cs which
/// connects to `/chatHub` and listens for HPPApprove, HPPDecline,
/// HPPCancel, and HPPFailed events.
class SignalRService {
  final String baseUrl;
  final Logger _log = Logger('SignalRService');

  HubConnection? _hubConnection;
  final StreamController<HppPaymentEvent> _paymentResultController =
      StreamController<HppPaymentEvent>.broadcast();

  /// Stream of payment results from the SignalR hub.
  Stream<HppPaymentEvent> get paymentResults =>
      _paymentResultController.stream;

  /// Whether the hub connection is currently active.
  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.Connected;

  SignalRService({required this.baseUrl});

  /// Connect to the SignalR hub and start listening for HPP events.
  ///
  /// [transactionGuid] is used to filter events so only events matching
  /// this transaction are emitted on the [paymentResults] stream.
  Future<void> connect({required String transactionGuid}) async {
    final hubUrl = '$baseUrl/chatHub';
    _log.info('Connecting to SignalR hub at $hubUrl');

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl)
        .withAutomaticReconnect()
        .build();

    _hubConnection!.onclose(({error}) {
      _log.warning('SignalR connection closed', error);
    });

    _hubConnection!.onreconnecting(({error}) {
      _log.info('SignalR reconnecting...', error);
    });

    _hubConnection!.onreconnected(({connectionId}) {
      _log.info('SignalR reconnected with id: $connectionId');
    });

    _registerHandlers(transactionGuid);

    try {
      await _hubConnection!.start();
      _log.info('SignalR connected successfully');
    } catch (e) {
      _log.severe('Failed to connect to SignalR hub', e);
      rethrow;
    }
  }

  void _registerHandlers(String transactionGuid) {
    _hubConnection!.on('HPPApprove', (arguments) {
      _handleEvent(
        arguments,
        transactionGuid,
        HppPaymentResult.approve,
      );
    });

    _hubConnection!.on('HPPDecline', (arguments) {
      _handleEvent(
        arguments,
        transactionGuid,
        HppPaymentResult.decline,
      );
    });

    _hubConnection!.on('HPPCancel', (arguments) {
      _handleEvent(
        arguments,
        transactionGuid,
        HppPaymentResult.cancel,
      );
    });

    _hubConnection!.on('HPPFailed', (arguments) {
      _handleEvent(
        arguments,
        transactionGuid,
        HppPaymentResult.failed,
      );
    });
  }

  void _handleEvent(
    List<Object?>? arguments,
    String transactionGuid,
    HppPaymentResult result,
  ) {
    if (arguments == null || arguments.isEmpty) return;

    final eventGuid = arguments[0]?.toString() ?? '';
    if (eventGuid != transactionGuid) return;

    _log.info('Received ${result.name} for transaction $transactionGuid');

    String? message;
    Map<String, dynamic>? data;

    if (arguments.length > 1) {
      final second = arguments[1];
      if (second is String) {
        message = second;
      } else if (second is Map) {
        data = Map<String, dynamic>.from(second);
      }
    }

    _paymentResultController.add(HppPaymentEvent(
      result: result,
      transactionGuid: transactionGuid,
      message: message,
      data: data,
    ));
  }

  /// Disconnect from the SignalR hub and clean up resources.
  Future<void> disconnect() async {
    _log.info('Disconnecting from SignalR hub');
    try {
      await _hubConnection?.stop();
    } catch (e) {
      _log.warning('Error stopping SignalR connection', e);
    }
    _hubConnection = null;
  }

  /// Dispose the service and close the stream controller.
  Future<void> dispose() async {
    await disconnect();
    await _paymentResultController.close();
  }
}
