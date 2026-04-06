import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notices_provider.dart';
import '../../models/notice_model.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});
  @override
  State<NoticesScreen> createState() => _State();
}

class _State extends State<NoticesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final u = context.read<AuthProvider>().currentUser;
      context.read<NoticesProvider>()
        .fetch(studentClass: u?.studentClass);
    });
  }

  Color _color(String c) {
    switch (c) {
      case 'urgent':   return AppColors.urgent;
      case 'academic': return AppColors.academic;
      case 'event':    return AppColors.event;
      default:         return AppColors.general;
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final p    = ctx.watch<NoticesProvider>();
    final role = ctx.watch<AuthProvider>().role;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Notices', style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              final u = ctx.read<AuthProvider>().currentUser;
              ctx.read<NoticesProvider>()
                .fetch(studentClass: u?.studentClass);
            }),
        ],
      ),
      floatingActionButton:
        (role == 'faculty' || role == 'admin')
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Post Notice',
                style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold)),
              onPressed: () => _showPost(ctx))
          : null,
      body: p.isLoading
        ? const Center(child: CircularProgressIndicator(
            color: AppColors.primary))
        : p.notices.isEmpty
          ? const Center(child: Text('No notices yet.'))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                final u = ctx.read<AuthProvider>().currentUser;
                await ctx.read<NoticesProvider>()
                  .fetch(studentClass: u?.studentClass);
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: p.notices.length,
                separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final n = p.notices[i];
                  final c = _color(n.category);
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8)]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: IntrinsicHeight(child: Row(
                        crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                        children: [
                          Container(width: 4, color: c),
                          Expanded(child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment:
                                CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets
                                      .symmetric(
                                        horizontal: 8,
                                        vertical: 2),
                                    decoration: BoxDecoration(
                                      color: c.withOpacity(0.1),
                                      borderRadius:
                                        BorderRadius.circular(6)),
                                    child: Text(
                                      n.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10, color: c,
                                        fontWeight:
                                          FontWeight.bold))),
                                  const Spacer(),
                                  Text(
                                    '${DateTime.now().difference(n.createdAt).inHours}h ago',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                                ]),
                                const SizedBox(height: 6),
                                Text(n.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(n.body,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13)),
                                const SizedBox(height: 8),
                                Text('Posted by ${n.author}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                              ],
                            ),
                          )),
                        ],
                      )),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _showPost(BuildContext ctx) {
    final titleCtrl = TextEditingController();
    final bodyCtrl  = TextEditingController();
    String cat = 'general';
    showModalBottomSheet(
      context: ctx, isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (ctx2, ss) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx2).viewInsets.bottom,
            left: 20, right: 20, top: 24),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Post a Notice',
                style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: bodyCtrl, maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: cat,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder()),
                items: ['general','urgent','academic','event']
                  .map((c) => DropdownMenuItem(
                    value: c, child: Text(c))).toList(),
                onChanged: (v) => ss(() => cat = v!)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14)),
                  onPressed: () async {
                    final user = ctx
                      .read<AuthProvider>().currentUser!;
                    final n = NoticeModel(
                      id: '', title: titleCtrl.text,
                      body: bodyCtrl.text, category: cat,
                      author: user.name,
                      createdAt: DateTime.now());
                    await ctx.read<NoticesProvider>().post(n);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Publish',
                    style: TextStyle(
                      fontWeight: FontWeight.bold)))),
              const SizedBox(height: 24),
            ]),
        ),
      ),
    );
  }
}