import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/constants/colors.dart';

class MoodleScreen extends StatefulWidget {
  const MoodleScreen({super.key});
  @override
  State<MoodleScreen> createState() => _State();
}

class _State extends State<MoodleScreen> {
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
        'https://www.mahindrauniversity.edu.in'));
  }

  @override
  Widget build(BuildContext _) => Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.primary,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mahindra University',
            style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold, fontSize: 16)),
          Text('mahindrauniversity.edu.in',
            style: TextStyle(color: Colors.white70,
              fontSize: 11)),
        ]),
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