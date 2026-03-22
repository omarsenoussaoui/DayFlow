import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'DayFlow',
      'home': 'Home',
      'manageDailyTasks': 'Manage Daily Tasks',
      'manageReminders': 'Manage Reminders',
      'about': 'About',
      'dailyTasks': 'DAILY TASKS',
      'reminders': 'REMINDERS',
      'quickTasks': 'QUICK TASKS',
      'addQuickTask': 'Add Quick Task',
      'taskName': 'Task name',
      'addTask': 'Add Task',
      'pickDate': 'Pick a date',
      'noDailyTasks': 'No daily tasks configured',
      'noReminders': 'No reminders for this day',
      'tapToAddQuick': 'Tap + to add a quick task',
      'dailyTasksTitle': 'Daily Tasks',
      'newDailyTask': 'New Daily Task',
      'editDailyTask': 'Edit Daily Task',
      'save': 'Save',
      'deleteTask': 'Delete Task',
      'deleteConfirm': 'Delete "{title}"? This cannot be undone.',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'noDailyTasksYet': 'No daily tasks yet',
      'dailyTasksAppearEveryDay': 'These tasks will appear every day',
      'remindersTitle': 'Reminders',
      'newReminder': 'New Reminder',
      'editReminder': 'Edit Reminder',
      'reminderName': 'Reminder name',
      'addReminder': 'Add Reminder',
      'deleteReminder': 'Delete Reminder',
      'noRemindersYet': 'No reminders yet',
      'addReminderToGetNotified': 'Add a reminder to get notified',
      'aboutTitle': 'About',
      'version': 'Version 1.0.0',
      'aboutDescription':
          'A minimal, offline-first daily task manager.\nBuilt with Flutter.',
      'language': 'Language',
      'english': 'English',
      'arabic': 'العربية',
      'selectDays': 'Select days',
      'allDays': 'Every day',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
    },
    'ar': {
      'appName': 'DayFlow',
      'home': 'الرئيسية',
      'manageDailyTasks': 'إدارة المهام اليومية',
      'manageReminders': 'إدارة التذكيرات',
      'about': 'حول التطبيق',
      'dailyTasks': 'المهام اليومية',
      'reminders': 'التذكيرات',
      'quickTasks': 'المهام السريعة',
      'addQuickTask': 'إضافة مهمة سريعة',
      'taskName': 'اسم المهمة',
      'addTask': 'إضافة مهمة',
      'pickDate': 'اختيار تاريخ',
      'noDailyTasks': 'لا توجد مهام يومية',
      'noReminders': 'لا توجد تذكيرات لهذا اليوم',
      'tapToAddQuick': 'اضغط + لإضافة مهمة سريعة',
      'dailyTasksTitle': 'المهام اليومية',
      'newDailyTask': 'مهمة يومية جديدة',
      'editDailyTask': 'تعديل المهمة اليومية',
      'save': 'حفظ',
      'deleteTask': 'حذف المهمة',
      'deleteConfirm': 'حذف "{title}"؟ لا يمكن التراجع عن هذا.',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'noDailyTasksYet': 'لا توجد مهام يومية بعد',
      'dailyTasksAppearEveryDay': 'ستظهر هذه المهام كل يوم',
      'remindersTitle': 'التذكيرات',
      'newReminder': 'تذكير جديد',
      'editReminder': 'تعديل التذكير',
      'reminderName': 'اسم التذكير',
      'addReminder': 'إضافة تذكير',
      'deleteReminder': 'حذف التذكير',
      'noRemindersYet': 'لا توجد تذكيرات بعد',
      'addReminderToGetNotified': 'أضف تذكيرًا ليتم إشعارك',
      'aboutTitle': 'حول التطبيق',
      'version': 'الإصدار 1.0.0',
      'aboutDescription':
          'مدير مهام يومي بسيط يعمل بدون اتصال.\nمبني بـ Flutter.',
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      'selectDays': 'اختر الأيام',
      'allDays': 'كل يوم',
      'mon': 'اثنين',
      'tue': 'ثلاثاء',
      'wed': 'أربعاء',
      'thu': 'خميس',
      'fri': 'جمعة',
      'sat': 'سبت',
      'sun': 'أحد',
    },
  };

  String get appName => _localizedValues[locale.languageCode]!['appName']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get manageDailyTasks =>
      _localizedValues[locale.languageCode]!['manageDailyTasks']!;
  String get manageReminders =>
      _localizedValues[locale.languageCode]!['manageReminders']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get dailyTasks =>
      _localizedValues[locale.languageCode]!['dailyTasks']!;
  String get reminders =>
      _localizedValues[locale.languageCode]!['reminders']!;
  String get quickTasks =>
      _localizedValues[locale.languageCode]!['quickTasks']!;
  String get addQuickTask =>
      _localizedValues[locale.languageCode]!['addQuickTask']!;
  String get taskName => _localizedValues[locale.languageCode]!['taskName']!;
  String get addTask => _localizedValues[locale.languageCode]!['addTask']!;
  String get pickDate => _localizedValues[locale.languageCode]!['pickDate']!;
  String get noDailyTasks =>
      _localizedValues[locale.languageCode]!['noDailyTasks']!;
  String get noReminders =>
      _localizedValues[locale.languageCode]!['noReminders']!;
  String get tapToAddQuick =>
      _localizedValues[locale.languageCode]!['tapToAddQuick']!;
  String get dailyTasksTitle =>
      _localizedValues[locale.languageCode]!['dailyTasksTitle']!;
  String get newDailyTask =>
      _localizedValues[locale.languageCode]!['newDailyTask']!;
  String get editDailyTask =>
      _localizedValues[locale.languageCode]!['editDailyTask']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get deleteTask =>
      _localizedValues[locale.languageCode]!['deleteTask']!;
  String deleteConfirm(String title) =>
      _localizedValues[locale.languageCode]!['deleteConfirm']!
          .replaceAll('{title}', title);
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get noDailyTasksYet =>
      _localizedValues[locale.languageCode]!['noDailyTasksYet']!;
  String get dailyTasksAppearEveryDay =>
      _localizedValues[locale.languageCode]!['dailyTasksAppearEveryDay']!;
  String get remindersTitle =>
      _localizedValues[locale.languageCode]!['remindersTitle']!;
  String get newReminder =>
      _localizedValues[locale.languageCode]!['newReminder']!;
  String get editReminder =>
      _localizedValues[locale.languageCode]!['editReminder']!;
  String get reminderName =>
      _localizedValues[locale.languageCode]!['reminderName']!;
  String get addReminder =>
      _localizedValues[locale.languageCode]!['addReminder']!;
  String get deleteReminder =>
      _localizedValues[locale.languageCode]!['deleteReminder']!;
  String get noRemindersYet =>
      _localizedValues[locale.languageCode]!['noRemindersYet']!;
  String get addReminderToGetNotified =>
      _localizedValues[locale.languageCode]!['addReminderToGetNotified']!;
  String get aboutTitle =>
      _localizedValues[locale.languageCode]!['aboutTitle']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get aboutDescription =>
      _localizedValues[locale.languageCode]!['aboutDescription']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get arabic => _localizedValues[locale.languageCode]!['arabic']!;
  String get selectDays =>
      _localizedValues[locale.languageCode]!['selectDays']!;
  String get allDays => _localizedValues[locale.languageCode]!['allDays']!;

  /// Day names indexed by weekday number (1=Mon, 7=Sun).
  static const _dayKeysEn = {
    1: 'mon', 2: 'tue', 3: 'wed', 4: 'thu',
    5: 'fri', 6: 'sat', 7: 'sun',
  };

  String dayName(int weekday) =>
      _localizedValues[locale.languageCode]![_dayKeysEn[weekday]!]!;

  /// Returns a short summary of selected days, e.g. "Mon, Wed, Fri" or "كل يوم".
  String daysSummary(String daysStr) {
    final list = daysStr.split(',').map((d) => int.parse(d.trim())).toList()..sort();
    if (list.length == 7) return allDays;
    return list.map((d) => dayName(d)).join(', ');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
