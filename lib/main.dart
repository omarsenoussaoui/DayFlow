import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/daily_task_provider.dart';
import 'providers/notification_task_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/counter_provider.dart';
import 'providers/quick_task_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  await NotificationService().requestPermissions();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('ar_EG');

  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider(create: (_) => DailyTaskProvider()),
        ChangeNotifierProvider(create: (_) => NotificationTaskProvider()),
        ChangeNotifierProvider(create: (_) => QuickTaskProvider()),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
      ],
      child: const DayFlowApp(),
    ),
  );
}
