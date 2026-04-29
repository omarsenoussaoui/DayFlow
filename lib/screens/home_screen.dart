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
  final _quickTaskController = TextEditingController();
  int? _editingQuickTaskId;
  final _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quickTaskController.dispose();
    _editController.dispose();
    super.dispose();
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
    setState(() {
      _selectedDate = date;
      _editingQuickTaskId = null;
    });
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

  void _addQuickTask() {
    final title = _quickTaskController.text.trim();
    if (title.isEmpty) return;
    context.read<QuickTaskProvider>().addTask(
          title,
          DateHelpers.toDateString(_selectedDate),
        );
    _quickTaskController.clear();
  }

  void _startEditing(int taskId, String currentTitle) {
    setState(() {
      _editingQuickTaskId = taskId;
      _editController.text = currentTitle;
    });
  }

  void _saveEdit(int taskId) {
    final newTitle = _editController.text.trim();
    if (newTitle.isEmpty) return;
    final dateStr = DateHelpers.toDateString(_selectedDate);
    final provider = context.read<QuickTaskProvider>();
    final task = provider.tasks.firstWhere((t) => t.id == taskId);
    provider.updateTask(task.copyWith(title: newTitle), dateStr);
    setState(() => _editingQuickTaskId = null);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LocaleProvider>().isArabic;

    return Scaffold(
      drawer: const AppDrawer(),
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
                      DateHelpers.formatDateFull(
                          _selectedDate, isArabic ? 'ar' : 'en'),
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
                  padding: const EdgeInsets.only(bottom: 24),
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
                    _buildQuickTaskInput(l10n),
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
        return ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          onReorder: (oldIndex, newIndex) {
            provider.reorderTasksForDay(oldIndex, newIndex);
          },
          proxyDecorator: (child, index, animation) {
            return Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black.withValues(alpha: 0.2),
              child: child,
            );
          },
          itemBuilder: (context, index) {
            final task = tasks[index];
            final isDone = provider.isTaskDone(task.id!);
            return TaskCard(
              key: ValueKey(task.id),
              title: task.title,
              isDone: isDone,
              onToggle: () => provider.toggleCompletion(task.id!),
            );
          },
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<QuickTaskProvider>(
      builder: (context, provider, _) {
        if (provider.tasks.isEmpty) {
          return _buildEmptyHint(l10n.tapToAddQuick);
        }
        return Column(
          children: provider.tasks.map((task) {
            final isEditing = _editingQuickTaskId == task.id;

            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    // Checkbox
                    Checkbox(
                      value: task.isDone,
                      onChanged: (_) => provider.toggleDone(
                          task.id!, !task.isDone, dateStr),
                    ),
                    // Label or edit field
                    Expanded(
                      child: isEditing
                          ? TextField(
                              controller: _editController,
                              autofocus: true,
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 8),
                              ),
                              onSubmitted: (_) => _saveEdit(task.id!),
                            )
                          : GestureDetector(
                              onTap: () =>
                                  _startEditing(task.id!, task.title),
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: task.isDone
                                      ? (isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary)
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary),
                                ),
                              ),
                            ),
                    ),
                    // Delete button
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                      onPressed: () =>
                          provider.deleteTask(task.id!, dateStr),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// Inline text field to add a new quick task.
  Widget _buildQuickTaskInput(AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.add_rounded,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _quickTaskController,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: l10n.addQuickTask,
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _addQuickTask(),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              onPressed: _addQuickTask,
            ),
          ],
        ),
      ),
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
          color:
              isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
