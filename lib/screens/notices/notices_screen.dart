import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/notice_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notices_provider.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
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

  void _showPostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedCategory = 'general';
    String? selectedClass;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Post Notice',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['general', 'urgent', 'academic', 'event']
                      .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c[0].toUpperCase() + c.substring(1))))
                      .toList(),
                  onChanged: (v) =>
                      setModalState(() => selectedCategory = v ?? 'general'),
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Target class (leave blank for all)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => selectedClass = v.trim().isEmpty ? null : v.trim(),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final noticesProvider = context.read<NoticesProvider>();
                    final notice = NoticeModel(
                      id: '',
                      title: titleController.text,
                      body: bodyController.text,
                      category: selectedCategory,
                      author: auth.currentUser?.name ?? 'Faculty',
                      targetClass: selectedClass,
                    );
                    await noticesProvider.post(notice);
                    if (ctx.mounted) Navigator.pop(ctx);
                    await noticesProvider.fetch(
                      studentClass: auth.currentUser?.studentClass,
                    );
                  },
                  child: const Text('Publish',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final notices = context.watch<NoticesProvider>();
    final isFaculty = auth.role == 'faculty' || auth.role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Notices', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => notices.fetch(
              studentClass: auth.currentUser?.studentClass,
            ),
          )
        ],
      ),
      floatingActionButton: isFaculty
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showPostDialog(context),
            )
          : null,
      body: notices.isLoading
          ? const Center(child: CircularProgressIndicator())
          : notices.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(notices.error!,
                          style: const TextStyle(color: AppColors.error)),
                    ],
                  ),
                )
              : notices.notices.isEmpty
                  ? const Center(
                      child: Text('No notices yet.',
                          style: TextStyle(color: AppColors.textSecondary)))
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => notices.fetch(
                        studentClass: auth.currentUser?.studentClass,
                      ),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notices.notices.length,
                        itemBuilder: (ctx, i) =>
                            _NoticeCard(notice: notices.notices[i]),
                      ),
                    ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeModel notice;
  const _NoticeCard({required this.notice});

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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _categoryColor, width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _categoryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notice.category.toUpperCase(),
                  style: TextStyle(
                      color: _categoryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (notice.isPinned) ...[
                const SizedBox(width: 8),
                const Icon(Icons.push_pin, size: 14, color: AppColors.primary),
              ]
            ],
          ),
          const SizedBox(height: 8),
          Text(notice.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(notice.body,
              style: const TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(notice.author,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
              if (notice.targetClass != null) ...[
                const SizedBox(width: 12),
                const Icon(Icons.class_outlined,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(notice.targetClass!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}