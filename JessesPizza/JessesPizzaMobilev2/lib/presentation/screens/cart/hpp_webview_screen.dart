import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:jesses_pizza_app/app/di.dart';
import 'package:jesses_pizza_app/data/services/signalr_service.dart';

/// Result returned when popping this screen.
class HppResult {
  final HppPaymentResult paymentResult;
  final String? message;
  final Map<String, dynamic>? data;

  const HppResult({
    required this.paymentResult,
    this.message,
    this.data,
  });
}

class HppWebviewScreen extends StatefulWidget {
  final String tokenUrl;
  final String transactionGuid;

  const HppWebviewScreen({
    super.key,
    required this.tokenUrl,
    required this.transactionGuid,
  });

  @override
  State<HppWebviewScreen> createState() => _HppWebviewScreenState();
}

class _HppWebviewScreenState extends State<HppWebviewScreen> {
  late final WebViewController _controller;
  late final SignalRService _signalRService;
  StreamSubscription<HppPaymentEvent>? _paymentSubscription;
  bool _isLoading = true;
  bool _hasHandledResult = false;

  @override
  void initState() {
    super.initState();
    _signalRService = getIt<SignalRService>();
    _connectSignalR();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            // Allow all navigation within the HPP flow
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.tokenUrl));
  }

  Future<void> _connectSignalR() async {
    try {
      await _signalRService.connect(
        transactionGuid: widget.transactionGuid,
      );
      _paymentSubscription =
          _signalRService.paymentResults.listen(_onPaymentResult);
    } catch (e) {
      if (mounted) {
        _popWithError('Unable to connect to payment service');
      }
    }
  }

  void _onPaymentResult(HppPaymentEvent event) {
    if (!mounted || _hasHandledResult) return;
    _hasHandledResult = true;

    switch (event.result) {
      case HppPaymentResult.approve:
        Navigator.of(context).pop(HppResult(
          paymentResult: HppPaymentResult.approve,
          data: event.data,
        ));
      case HppPaymentResult.decline:
        Navigator.of(context).pop(HppResult(
          paymentResult: HppPaymentResult.decline,
          message: 'Card was declined',
        ));
      case HppPaymentResult.cancel:
        Navigator.of(context).pop(HppResult(
          paymentResult: HppPaymentResult.cancel,
        ));
      case HppPaymentResult.failed:
        Navigator.of(context).pop(HppResult(
          paymentResult: HppPaymentResult.failed,
          message: event.message ??
              'Something went wrong processing your transaction',
        ));
    }
  }

  void _popWithError(String message) {
    if (!mounted || _hasHandledResult) return;
    _hasHandledResult = true;
    Navigator.of(context).pop(HppResult(
      paymentResult: HppPaymentResult.failed,
      message: message,
    ));
  }

  @override
  void dispose() {
    _paymentSubscription?.cancel();
    _signalRService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(HppResult(
            paymentResult: HppPaymentResult.cancel,
          )),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
