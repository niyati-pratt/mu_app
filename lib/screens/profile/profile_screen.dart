import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (user?.name.isNotEmpty == true)
                      ? user!.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _capitalize(user?.role ?? ''),
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 28),

            // Info card
            _InfoCard(children: [
              _InfoRow(Icons.email_outlined, 'Email', user?.email ?? ''),
              if (user?.department != null)
                _InfoRow(Icons.business_outlined, 'Department', user!.department!),
              if (user?.studentClass != null)
                _InfoRow(Icons.class_outlined, 'Class', user!.studentClass!),
            ]),

            const SizedBox(height: 16),

            // MU Contacts
            _InfoCard(children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('MU Contact Info',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary)),
              ),
              _InfoRow(Icons.phone_outlined, 'Phone', '+91-40-23120000'),
              _InfoRow(Icons.email_outlined, 'Email', 'admissions@mahindrauniversity.edu.in'),
              _InfoRow(Icons.location_on_outlined, 'Address',
                  'Survey No. 62/1A, Bahadurpally, Hyderabad 500043'),
            ]),

            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('Sign Out',
                    style: TextStyle(color: AppColors.error, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}