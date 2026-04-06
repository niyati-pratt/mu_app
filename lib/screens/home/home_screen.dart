import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notices_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final u = context.read<AuthProvider>().currentUser;
      context.read<NoticesProvider>()
        .fetch(studentClass: u?.studentClass);
    });
  }

  String _greet() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext ctx) {
    final user    = ctx.watch<AuthProvider>().currentUser;
    final notices = ctx.watch<NoticesProvider>();
    final name    = user?.name.split(' ').first ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${_greet()}, $name 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3)),
                  const SizedBox(height: 6),
                  Text(
                    user?.department ??
                      'Global Thinkers. Engaged Leaders.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                      fontSize: 14)),
                ],
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── QUICK ACCESS ──
              const Text('Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                _Card('📊', 'ERP\nPortal',
                  AppColors.primary,
                  () => ctx.push('/erp')),
                const SizedBox(width: 14),
                _Card('🌐', 'MU\nWebsite',
                  AppColors.moodle,
                  () => ctx.push('/moodle')),
                const SizedBox(width: 14),
                _Card('📢', 'Notice\nBoard',
                  const Color(0xFF1D4ED8),
                  () => ctx.go('/notices')),
              ]),

              const SizedBox(height: 32),

              // ── RECENT NOTICES ──
              const Text('Recent Notices',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              if (notices.isLoading)
                const Center(child: CircularProgressIndicator(
                  color: AppColors.primary))
              else if (notices.notices.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border)),
                  child: const Center(
                    child: Text('No notices yet.',
                      style: TextStyle(
                        color: AppColors.textSecondary))))
              else
                ...notices.notices.take(3).map((n) =>
                  _NoticeRow(n.title, n.category, n.author)),

              const SizedBox(height: 20),
            ],
          ),
        )),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  final String emoji, label;
  final Color color;
  final VoidCallback onTap;
  const _Card(this.emoji, this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext _) =>
    Expanded(child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(0.25),
            width: 1.5)),
        child: Column(children: [
          Text(emoji,
            style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.3)),
        ]),
      ),
    ));
}

class _NoticeRow extends StatelessWidget {
  final String title, category, author;
  const _NoticeRow(this.title, this.category, this.author);

  @override
  Widget build(BuildContext _) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2))
      ]),
    child: Row(children: [
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('$category • $author',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary)),
        ])),
      const SizedBox(width: 8),
      const Icon(Icons.chevron_right,
        color: AppColors.textSecondary, size: 20),
    ]),
  );
}