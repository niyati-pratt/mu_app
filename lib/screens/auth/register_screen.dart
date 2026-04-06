import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _State();
}

class _State extends State<RegisterScreen> {
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  final _form  = GlobalKey<FormState>();
  String _role = 'student';
  String? _err;

  @override
  void dispose() {
    _name.dispose(); _email.dispose();
    _pass.dispose(); super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _err = null);
    final err = await context.read<AuthProvider>().register(
      name: _name.text, email: _email.text,
      password: _pass.text, role: _role);
    if (err != null && mounted) {
      setState(() => _err = err);
    } else if (mounted) {
      context.go('/home');
    }
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
            const SizedBox(height: 40),
            const Text('Create Account',
              style: TextStyle(fontSize: 24,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Join Mahindra University',
              style: TextStyle(
                color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            TextFormField(controller: _name,
              decoration: _dec('Full Name', 'Your name'),
              validator: (v) => (v?.isEmpty ?? true)
                ? 'Enter name' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _dec('Email', 'you@mu.edu.in'),
              validator: (v) => (v?.isEmpty ?? true)
                ? 'Enter email' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _pass,
              obscureText: true,
              decoration: _dec('Password', '6+ characters'),
              validator: (v) => (v?.length ?? 0) < 6
                ? 'Min 6 characters' : null),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: _dec('Role', ''),
              items: ['student', 'faculty', 'parent']
                .map((r) => DropdownMenuItem(
                  value: r,
                  child: Text(r[0].toUpperCase() +
                    r.substring(1))))
                .toList(),
              onChanged: (v) =>
                setState(() => _role = v!)),
            if (_err != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3))),
                child: Text(_err!, style: const TextStyle(
                  color: AppColors.error))),
            ],
            const SizedBox(height: 28),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
                child: auth.isLoading
                  ? const SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                  : const Text('Register', style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
            Center(child: GestureDetector(
              onTap: () => ctx.pop(),
              child: RichText(text: const TextSpan(
                style: TextStyle(
                  color: AppColors.textSecondary),
                children: [
                  TextSpan(text: 'Already have account? '),
                  TextSpan(text: 'Login',
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