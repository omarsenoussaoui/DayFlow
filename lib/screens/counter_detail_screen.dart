import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';
import '../utils/constants.dart';

class CounterDetailScreen extends StatelessWidget {
  final int counterId;

  const CounterDetailScreen({super.key, required this.counterId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: Consumer<CounterProvider>(
        builder: (context, provider, _) {
          final counter = provider.counters.where((c) => c.id == counterId).firstOrNull;
          if (counter == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Counter label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    counter.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                // Counter value
                Text(
                  '${counter.count}',
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 48),
                // +/- buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Minus button
                    _CounterButton(
                      icon: Icons.remove_rounded,
                      onPressed: () => provider.decrement(counter.id!),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 48),
                    // Plus button
                    _CounterButton(
                      icon: Icons.add_rounded,
                      onPressed: () => provider.increment(counter.id!),
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  const _CounterButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkCard : AppColors.surface,
      shape: const CircleBorder(),
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            size: 36,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
