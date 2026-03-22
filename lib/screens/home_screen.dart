import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_task_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/notification_task_provider.dart';
import '../providers/quick_task_provider.dart';
import '../utils/date_helpers.dart';
import '../utils/constants.dart';
import '../widgets/task_card.dart';
import '../widgets/section_header.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dateStr = DateHelpers.toDateString(_selectedDate);
    final dailyProvider = context.read<DailyTaskProvider>();
    final notifProvider = context.read<NotificationTaskProvider>();
    final quickProvider = context.read<QuickTaskProvider>();

    await Future.wait([
      dailyProvider.loadTasks(),
      dailyProvider.loadCompletionsForDate(dateStr),
      notifProvider.loadTasksForDate(dateStr),
      quickProvider.loadTasksForDate(dateStr),
    ]);
  }

  void _onDateSelected(DateTime date) {
    setState(() => _selectedDate = date);
    final dateStr = DateHelpers.toDateString(date);
    context.read<DailyTaskProvider>().loadCompletionsForDate(dateStr);
    context.read<NotificationTaskProvider>().loadTasksForDate(dateStr);
    context.read<QuickTaskProvider>().loadTasksForDate(dateStr);
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      _onDateSelected(picked);
    }
  }

  void _showAddQuickTaskSheet() {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addQuickTask,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.taskName,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<QuickTaskProvider>().addTask(
                        value.trim(),
                        DateHelpers.toDateString(_selectedDate),
                      );
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    context.read<QuickTaskProvider>().addTask(
                          controller.text.trim(),
                          DateHelpers.toDateString(_selectedDate),
                        );
                    Navigator.pop(ctx);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.addTask),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LocaleProvider>().isArabic;

    return Scaffold(
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddQuickTaskSheet,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar area
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      DateHelpers.formatDateFull(_selectedDate, isArabic ? 'ar' : 'en'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    tooltip: l10n.pickDate,
                    onPressed: _showDatePicker,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Task list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    // Daily tasks section
                    SectionHeader(
                      title: l10n.dailyTasks,
                      icon: Icons.repeat_rounded,
                    ),
                    _buildDailyTasks(l10n),
                    // Reminders section
                    SectionHeader(
                      title: l10n.reminders,
                      icon: Icons.notifications_none_rounded,
                    ),
                    _buildNotificationTasks(l10n),
                    // Quick tasks section
                    SectionHeader(
                      title: l10n.quickTasks,
                      icon: Icons.flash_on_rounded,
                    ),
                    _buildQuickTasks(l10n),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTasks(AppLocalizations l10n) {
    return Consumer<DailyTaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.tasksForSelectedDay;
        if (tasks.isEmpty) {
          return _buildEmptyHint(l10n.noDailyTasks);
        }
        return Column(
          children: tasks.map((task) {
            final isDone = provider.isTaskDone(task.id!);
            return TaskCard(
              title: task.title,
              isDone: isDone,
              onToggle: () => provider.toggleCompletion(task.id!),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildNotificationTasks(AppLocalizations l10n) {
    return Consumer<NotificationTaskProvider>(
      builder: (context, provider, _) {
        if (provider.tasksForDate.isEmpty) {
          return _buildEmptyHint(l10n.noReminders);
        }
        return Column(
          children: provider.tasksForDate.map((task) {
            return TaskCard(
              title: task.title,
              isDone: task.isDone,
              onToggle: () => provider.toggleDone(task.id!, !task.isDone),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.notifications_active_rounded,
                size: 18,
                color: task.isDone
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.divider)
                    : AppColors.primary,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildQuickTasks(AppLocalizations l10n) {
    final dateStr = DateHelpers.toDateString(_selectedDate);
    return Consumer<QuickTaskProvider>(
      builder: (context, provider, _) {
        if (provider.tasks.isEmpty) {
          return _buildEmptyHint(l10n.tapToAddQuick);
        }
        return Column(
          children: provider.tasks.map((task) {
            return Dismissible(
              key: ValueKey(task.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              onDismissed: (_) => provider.deleteTask(task.id!, dateStr),
              child: TaskCard(
                title: task.title,
                isDone: task.isDone,
                onToggle: () =>
                    provider.toggleDone(task.id!, !task.isDone, dateStr),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyHint(String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
