import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/app_colors.dart';

class ERPScreen extends StatefulWidget {
  const ERPScreen({super.key});

  @override
  State<ERPScreen> createState() => _ERPScreenState();
}

class _ERPScreenState extends State<ERPScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  double _progress = 0;

  static const String _erpUrl =
      'https://muerp.mahindrauniversity.edu.in/login.htm';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          setState(() => _progress = progress / 100);
        },
        onPageFinished: (_) {
          setState(() => _loading = false);
          // Inject mobile viewport meta for proper rendering
          _controller.runJavaScript('''
            (function() {
              var meta = document.querySelector('meta[name="viewport"]');
              if (!meta) {
                meta = document.createElement('meta');
                meta.name = 'viewport';
                document.head.appendChild(meta);
              }
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0';
            })();
          ''');
        },
        onWebResourceError: (_) {
          setState(() => _loading = false);
        },
      ))
      ..loadRequest(Uri.parse(_erpUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.erp,
        title: const Text('ERP Portal', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _controller.reload();
            },
          ),
        ],
        bottom: _loading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}