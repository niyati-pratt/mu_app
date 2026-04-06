import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/colors.dart';

class ERPScreen extends StatefulWidget {
  const ERPScreen({super.key});
  @override
  State<ERPScreen> createState() => _State();
}

class _State extends State<ERPScreen> {
  late final WebViewController _ctrl;
  bool _loading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) =>
          setState(() => _progress = p / 100),
        onPageFinished: (_) =>
          setState(() => _loading = false),
      ))
      ..loadRequest(Uri.parse(
        'https://muerp.mahindrauniversity.edu.in/login.htm'));
  }

  @override
  Widget build(BuildContext _) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.primary,
      title: const Text('MU ERP Portal',
        style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold)),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: _ctrl.reload),
      ],
      bottom: _loading ? PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: LinearProgressIndicator(
          value: _progress > 0 ? _progress : null,
          backgroundColor: AppColors.primaryDark,
          color: Colors.white)) : null,
    ),
    body: WebViewWidget(controller: _ctrl),
  );
}