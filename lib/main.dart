import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/constants/colors.dart';
import 'providers/auth_provider.dart';
import 'providers/notices_provider.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => NoticesProvider()),
    ],
    child: const MUApp(),
  ));
}

class MUApp extends StatelessWidget {
  const MUApp({super.key});
  @override
  Widget build(BuildContext context) =>
    MaterialApp.router(
      title: 'Mahindra University',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: appRouter,
    );
}