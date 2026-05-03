import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notices_provider.dart';
import '../../models/notice_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      context.read<NoticesProvider>().fetch(
        studentClass: auth.currentUser?.studentClass,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notices = context.watch<NoticesProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with red gradient
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Hello, ${user?.name.split(' ').first ?? 'there'}! 👋',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_capitalize(user?.role ?? '')} · Mahindra University',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Quick access cards
                const Text('Quick Access',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickCard(
                        icon: Icons.business,
                        label: 'ERP Portal',
                        color: AppColors.erp,
                        onTap: () => context.push('/erp'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickCard(
                        icon: Icons.language,
                        label: 'MU Website',
                        color: AppColors.moodle,
                        onTap: () => context.push('/website'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickCard(
                        icon: Icons.notifications,
                        label: 'Notices',
                        color: AppColors.primary,
                        onTap: () => context.go('/notices'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent notices
                const Text('Recent Notices',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 12),

                if (notices.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (notices.error != null)
                  Text(notices.error!,
                      style: const TextStyle(color: AppColors.error))
                else if (notices.notices.isEmpty)
                  const Text('No notices yet.',
                      style: TextStyle(color: AppColors.textSecondary))
                else
                  ...notices.notices.take(3).map((n) => _NoticePreviewCard(notice: n)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

class _NoticePreviewCard extends StatelessWidget {
  final NoticeModel notice;
  const _NoticePreviewCard({required this.notice});

  Color get _categoryColor {
    switch (notice.category) {
      case 'urgent': return AppColors.urgent;
      case 'academic': return AppColors.academic;
      case 'event': return AppColors.event;
      default: return AppColors.general;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: _categoryColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notice.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14,
                  color: AppColors.textPrimary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(notice.body,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text('By ${notice.author}',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}