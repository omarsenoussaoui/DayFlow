import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/calorie_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/constants.dart';
import '../utils/date_helpers.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  State<CaloriesScreen> createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    final provider = context.read<CalorieProvider>();
    provider.loadGoal();
    provider.loadEntriesForDate(DateHelpers.toDateString(_currentDate));
  }

  void _goToPreviousDay() {
    setState(
        () => _currentDate = _currentDate.subtract(const Duration(days: 1)));
    context.read<CalorieProvider>().goToDate(_currentDate);
  }

  void _goToNextDay() {
    setState(() => _currentDate = _currentDate.add(const Duration(days: 1)));
    context.read<CalorieProvider>().goToDate(_currentDate);
  }

  void _showSetGoalDialog() {
    final provider = context.read<CalorieProvider>();
    final controller = TextEditingController(text: '${provider.goal}');
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
              l10n.setCalorieGoal,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: l10n.calorieGoalHint,
                suffixText: l10n.cal,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final goal = int.tryParse(controller.text.trim());
                  if (goal != null && goal > 0) {
                    provider.setGoal(goal);
                    Navigator.pop(ctx);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeightDialog() {
    final provider = context.read<CalorieProvider>();
    final controller = TextEditingController(
      text: provider.weight != null ? '${provider.weight}' : '',
    );
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
              l10n.todayWeight,
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: l10n.weightHint,
                suffixText: l10n.kg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final weight = double.tryParse(controller.text.trim());
                  if (weight != null && weight > 0) {
                    provider.setWeight(weight);
                    Navigator.pop(ctx);
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.save),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows bottom sheet with a toggle: Food (+) or Sport (-)
  void _showAddEntryDialog() {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    bool isFood = true; // true = food (+), false = sport (-)

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
                l10n.addCalorieEntry,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Food / Sport toggle
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setSheetState(() => isFood = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isFood
                              ? AppColors.completedGreen.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isFood
                                ? AppColors.completedGreen
                                : (isDark
                                    ? const Color(0xFF424242)
                                    : AppColors.divider),
                            width: isFood ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_rounded,
                              size: 18,
                              color: isFood
                                  ? AppColors.completedGreen
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.food,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isFood
                                    ? AppColors.completedGreen
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setSheetState(() => isFood = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isFood
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: !isFood
                                ? AppColors.primary
                                : (isDark
                                    ? const Color(0xFF424242)
                                    : AppColors.divider),
                            width: !isFood ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center_rounded,
                              size: 18,
                              color: !isFood
                                  ? AppColors.primary
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.sport,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: !isFood
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: isFood ? l10n.foodName : l10n.sportName,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: calController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.caloriesAmount,
                  suffixText: l10n.cal,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final cal = int.tryParse(calController.text.trim());
                    if (name.isEmpty || cal == null || cal <= 0) return;
                    // Food = positive, Sport = negative
                    final calories = isFood ? cal : -cal;
                    context.read<CalorieProvider>().addEntry(name, calories);
                    Navigator.pop(ctx);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.addEntry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final locale = isArabic ? 'ar' : 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.caloriesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.monitor_weight_rounded),
            tooltip: l10n.todayWeight,
            onPressed: _showWeightDialog,
          ),
          IconButton(
            icon: const Icon(Icons.flag_rounded),
            tooltip: l10n.setCalorieGoal,
            onPressed: _showSetGoalDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEntryDialog,
        child: const Icon(Icons.add),
      ),
      body: Consumer<CalorieProvider>(
        builder: (context, provider, _) {
          final diff = provider.difference;

          return Column(
            children: [
              // Date navigation
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: _goToPreviousDay,
                    ),
                    Text(
                      DateHelpers.formatDateFull(_currentDate, locale),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: _goToNextDay,
                    ),
                  ],
                ),
              ),
              // Summary card
              Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Weight row (if set)
                      if (provider.weight != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.monitor_weight_rounded,
                                  size: 16,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.weight,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${provider.weight} ${l10n.kg}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      // Goal
                      _summaryRow(
                        l10n.dailyGoal,
                        '${provider.goal} ${l10n.cal}',
                        isDark,
                      ),
                      const SizedBox(height: 8),
                      // Food eaten
                      _summaryRow(
                        l10n.food,
                        '+${provider.totalFood} ${l10n.cal}',
                        isDark,
                        valueColor: AppColors.completedGreen,
                      ),
                      const SizedBox(height: 8),
                      // Burned
                      _summaryRow(
                        l10n.sport,
                        '-${provider.totalBurned} ${l10n.cal}',
                        isDark,
                        valueColor: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      // Net
                      _summaryRow(
                        l10n.netCalories,
                        '${provider.netCalories} ${l10n.cal}',
                        isDark,
                      ),
                      const Divider(height: 24),
                      // Difference
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.difference,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${diff > 0 ? '+' : ''}$diff ${l10n.cal}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: diff > 0
                                  ? AppColors.error
                                  : diff < 0
                                      ? AppColors.completedGreen
                                      : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        diff > 0
                            ? l10n.overGoal
                            : diff < 0
                                ? l10n.underGoal
                                : l10n.exactGoal,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Entries list
              Expanded(
                child: provider.entries.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noCalorieEntries,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: provider.entries.length,
                        itemBuilder: (context, index) {
                          final entry = provider.entries[index];
                          final isBurned = entry.calories < 0;
                          return Card(
                            child: ListTile(
                              leading: Icon(
                                isBurned
                                    ? Icons.fitness_center_rounded
                                    : Icons.restaurant_rounded,
                                color: isBurned
                                    ? AppColors.primary
                                    : AppColors.completedGreen,
                              ),
                              title: Text(
                                entry.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${isBurned ? '' : '+'}${entry.calories} ${l10n.cal}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isBurned
                                          ? AppColors.primary
                                          : AppColors.completedGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.textSecondary,
                                    ),
                                    onPressed: () =>
                                        provider.deleteEntry(entry.id!),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isDark,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ??
                (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
