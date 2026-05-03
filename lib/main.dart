import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/notices_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MUApp());
}

class MUApp extends StatefulWidget {
  const MUApp({super.key});

  @override
  State<MUApp> createState() => _MUAppState();
}

class _MUAppState extends State<MUApp> {
  late final AuthProvider _authProvider;
  late final NoticesProvider _noticesProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _noticesProvider = NoticesProvider();
    _router = createRouter(_authProvider);
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _noticesProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider.value(value: _noticesProvider),
      ],
      child: MaterialApp.router(
        title: 'MU App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC8102E),
          ),
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }
}