import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HppWebviewScreen extends StatefulWidget {
  final String tokenUrl;

  const HppWebviewScreen({super.key, required this.tokenUrl});

  @override
  State<HppWebviewScreen> createState() => _HppWebviewScreenState();
}

class _HppWebviewScreenState extends State<HppWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            // Detect redirect back from Converge (adjust pattern as needed)
            if (url.contains('payment-complete') ||
                url.contains('converge_redirect')) {
              Navigator.of(context).pop(true);
            }
          },
          onNavigationRequest: (request) {
            // Allow all navigation within the HPP flow
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.tokenUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
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
