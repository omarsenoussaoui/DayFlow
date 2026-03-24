import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/counter_provider.dart';
import '../models/counter.dart';
import '../utils/constants.dart';
import 'counter_detail_screen.dart';

class ManageCountersScreen extends StatefulWidget {
  const ManageCountersScreen({super.key});

  @override
  State<ManageCountersScreen> createState() => _ManageCountersScreenState();
}

class _ManageCountersScreenState extends State<ManageCountersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CounterProvider>().loadCounters();
  }

  void _showCounterDialog({Counter? counter}) {
    final labelController = TextEditingController(text: counter?.label ?? '');
    final countController = TextEditingController(
      text: counter != null ? '${counter.count}' : '0',
    );
    final isEditing = counter != null;
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
              isEditing ? l10n.editCounter : l10n.newCounter,
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
              controller: labelController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.counterLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: l10n.initialCount,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final label = labelController.text.trim();
                  if (label.isEmpty) return;
                  final count = int.tryParse(countController.text.trim()) ?? 0;

                  final provider = context.read<CounterProvider>();
                  if (isEditing) {
                    provider.updateCounter(
                      counter!.copyWith(label: label, count: count),
                    );
                  } else {
                    provider.addCounter(label, count);
                  }
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isEditing ? l10n.save : l10n.addCounter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Counter counter) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCounter),
        content: Text(l10n.deleteCounterConfirm(counter.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              context.read<CounterProvider>().deleteCounter(counter.id!);
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
        title: Text(l10n.countersTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCounterDialog(),
        child: const Icon(Icons.add),
      ),
      body: Consumer<CounterProvider>(
        builder: (context, provider, _) {
          if (provider.counters.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pin_rounded,
                    size: 64,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.divider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noCountersYet,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.counters.length,
            itemBuilder: (context, index) {
              final counter = provider.counters[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CounterDetailScreen(counterId: counter.id!),
                      ),
                    );
                  },
                  title: Text(
                    counter.label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${counter.count}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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
                        onPressed: () => _showCounterDialog(counter: counter),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        onPressed: () => _confirmDelete(counter),
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
