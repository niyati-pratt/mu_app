import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _State();
}

class _State extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  final _form  = GlobalKey<FormState>();
  bool _hide = true;
  String? _err;

  @override
  void dispose() {
    _email.dispose(); _pass.dispose(); super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _err = null);
    final err = await context.read<AuthProvider>()
      .login(_email.text, _pass.text);
    if (err != null && mounted) setState(() => _err = err);
  }

  @override
  Widget build(BuildContext ctx) {
    final auth = ctx.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(key: _form, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            Center(child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.school_rounded,
                color: Colors.white, size: 36))),
            const SizedBox(height: 32),
            const Text('Welcome Back 👋',
              style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Sign in to Mahindra University',
              style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 36),
            TextFormField(controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Email', 'you@mu.edu.in'),
              validator: (v) => (v?.isEmpty ?? true)
                ? 'Enter email' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _pass,
              obscureText: _hide,
              decoration: _dec('Password', '••••••••').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_hide
                    ? Icons.visibility_off
                    : Icons.visibility),
                  onPressed: () =>
                    setState(() => _hide = !_hide))),
              validator: (v) => (v?.isEmpty ?? true)
                ? 'Enter password' : null),
            if (_err != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3))),
                child: Row(children: [
                  const Icon(Icons.error_outline,
                    color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Text(_err!, style: const TextStyle(
                    color: AppColors.error)),
                ])),
            ],
            const SizedBox(height: 28),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
                child: auth.isLoading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                  : const Text('Sign In', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
            Center(child: GestureDetector(
              onTap: () => ctx.push('/register'),
              child: RichText(text: const TextSpan(
                style: TextStyle(
                  color: AppColors.textSecondary),
                children: [
                  TextSpan(text: 'No account? '),
                  TextSpan(text: 'Register',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold)),
                ])))),
          ],
        )),
      )),
    );
  }

  InputDecoration _dec(String l, String h) =>
    InputDecoration(
      labelText: l, hintText: h,
      filled: true, fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary, width: 2)),
    );
}