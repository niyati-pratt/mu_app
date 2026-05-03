import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/app_colors.dart';

class MoodleScreen extends StatefulWidget {
  const MoodleScreen({super.key});

  @override
  State<MoodleScreen> createState() => _MoodleScreenState();
}

class _MoodleScreenState extends State<MoodleScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  double _progress = 0;

  static const String _muUrl = 'https://www.mahindrauniversity.edu.in';

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
        },
        onWebResourceError: (_) {
          setState(() => _loading = false);
        },
      ))
      ..loadRequest(Uri.parse(_muUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.moodle,
        title: const Text('MU Website', style: TextStyle(color: Colors.white)),
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