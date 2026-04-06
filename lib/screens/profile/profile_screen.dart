import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    final user = ctx.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile', style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person_rounded,
                color: Colors.white, size: 40))),
            const SizedBox(height: 20),
            Center(child: Text(user?.name ?? '',
              style: const TextStyle(fontSize: 22,
                fontWeight: FontWeight.bold))),
            const SizedBox(height: 6),
            Center(child: Text(user?.email ?? '',
              style: const TextStyle(
                color: AppColors.textSecondary))),
            const SizedBox(height: 12),
            Center(child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3))),
              child: Text(
                (user?.role?.isNotEmpty == true)
                  ? user!.role[0].toUpperCase() + user.role.substring(1) 
                  : '',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold)))),
            const SizedBox(height: 40),
            const Text('University Contact',
              style: TextStyle(fontSize: 16,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _InfoRow(Icons.phone_outlined,
              '040-67135100'),
            _InfoRow(Icons.email_outlined,
              'info@mahindrauniversity.edu.in'),
            _InfoRow(Icons.location_on_outlined,
              'Bahadurpally, Hyderabad'),
            const Spacer(),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () =>
                  ctx.read<AuthProvider>().logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14))),
                child: const Text('Logout',
                  style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext _) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.textSecondary),
      const SizedBox(width: 10),
      Text(text, style: const TextStyle(
        color: AppColors.textSecondary)),
    ]),
  );
}