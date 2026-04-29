import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_task_provider.dart';
import '../models/daily_task.dart';
import '../utils/constants.dart';

class ManageDailyTasksScreen extends StatefulWidget {
  const ManageDailyTasksScreen({super.key});

  @override
  State<ManageDailyTasksScreen> createState() =>
      _ManageDailyTasksScreenState();
}

class _ManageDailyTasksScreenState extends State<ManageDailyTasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DailyTaskProvider>().loadTasks();
  }

  void _showTaskDialog({DailyTask? task}) {
    final controller = TextEditingController(text: task?.title ?? '');
    final isEditing = task != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    // Selected days: default all days for new task
    Set<int> selectedDays = task != null
        ? task.dayList.toSet()
        : {1, 2, 3, 4, 5, 6, 7};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? l10n.editDailyTask : l10n.newDailyTask,
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
              ),
              const SizedBox(height: 16),
              // Day selection label
              Text(
                l10n.selectDays,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              // Day chips — order: Sun(7), Mon(1)..Sat(6)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [7, 1, 2, 3, 4, 5, 6].map((day) {
                  final isSelected = selectedDays.contains(day);
                  return FilterChip(
                    label: Text(l10n.dayName(day)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setSheetState(() {
                        if (selected) {
                          selectedDays.add(day);
                        } else {
                          // Don't allow deselecting all days
                          if (selectedDays.length > 1) {
                            selectedDays.remove(day);
                          }
                        }
                      });
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final title = controller.text.trim();
                    if (title.isEmpty) return;

                    final daysList = selectedDays.toList()..sort();
                    final daysStr = daysList.join(',');

                    final provider = context.read<DailyTaskProvider>();
                    if (isEditing) {
                      provider.updateTask(
                          task!.copyWith(title: title, days: daysStr));
                    } else {
                      provider.addTask(title, daysStr);
                    }
                    Navigator.pop(ctx);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(isEditing ? l10n.save : l10n.addTask),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(DailyTask task) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.deleteConfirm(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              context.read<DailyTaskProvider>().deleteTask(task.id!);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailyTasksTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<DailyTaskProvider>(
        builder: (context, provider, _) {
          if (provider.allTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.repeat_rounded,
                    size: 64,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.divider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noDailyTasksYet,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.dailyTasksAppearEveryDay,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.allTasks.length,
            onReorder: (oldIndex, newIndex) {
              provider.reorderTasks(oldIndex, newIndex);
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) => Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                  child: child,
                ),
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final task = provider.allTasks[index];
              return Card(
                key: ValueKey(task.id),
                child: ListTile(
                  leading: Icon(
                    Icons.drag_handle_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    l10n.daysSummary(task.days),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit_rounded,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => _showTaskDialog(task: task),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        onPressed: () => _confirmDelete(task),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
