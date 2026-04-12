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
      'counters': 'COUNTERS',
      'manageCounters': 'Manage Counters',
      'countersTitle': 'Counters',
      'newCounter': 'New Counter',
      'editCounter': 'Edit Counter',
      'counterLabel': 'Counter label',
      'addCounter': 'Add Counter',
      'deleteCounter': 'Delete Counter',
      'deleteCounterConfirm': 'Delete "{title}"? This cannot be undone.',
      'noCounters': 'No counters for this day',
      'noCountersYet': 'No counters yet',
      'countersTrackPerDay': 'Counters track values per day',
      'initialCount': 'Initial count',
      'manageQuickTasks': 'Manage Quick Tasks',
      'quickTasksTitle': 'Quick Tasks',
      'newQuickTask': 'New Quick Task',
      'editQuickTask': 'Edit Quick Task',
      'quickTaskName': 'Task name',
      'deleteQuickTask': 'Delete Quick Task',
      'noQuickTasksYet': 'No quick tasks yet',
      'quickTasksAppearOnDate': 'Quick tasks appear on their assigned date',
      'selectDate': 'Select date',
      'notes': 'Notes',
      'notesTitle': 'Notes',
      'manageNotes': 'Notes',
      'newNote': 'New Note',
      'editNote': 'Edit Note',
      'noteTitle': 'Title',
      'noteDescription': 'Description',
      'addNote': 'Add Note',
      'deleteNote': 'Delete Note',
      'deleteNoteConfirm': 'Delete "{title}"? This cannot be undone.',
      'noNotesYet': 'No notes yet',
      'notesHint': 'Save things you want to remember',
      'caloriesTitle': 'Calories',
      'calories': 'Calories',
      'setCalorieGoal': 'Set Daily Goal',
      'calorieGoalHint': 'Daily calorie goal',
      'cal': 'cal',
      'addCalorieEntry': 'Add Food Entry',
      'foodName': 'Food name',
      'caloriesAmount': 'Calories',
      'addEntry': 'Add Entry',
      'dailyGoal': 'Daily Goal',
      'totalEaten': 'Total Eaten',
      'difference': 'Difference',
      'overGoal': 'You exceeded your goal, need to burn more',
      'underGoal': 'You still need more calories',
      'exactGoal': 'You hit your goal exactly!',
      'noCalorieEntries': 'No entries yet, tap + to add food',
      'food': 'Food',
      'sport': 'Sport',
      'sportName': 'Activity name',
      'netCalories': 'Net Calories',
      'todayWeight': 'Today\'s Weight',
      'weight': 'Weight',
      'weightHint': 'Your weight',
      'kg': 'kg',
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
      'counters': 'العدّادات',
      'manageCounters': 'إدارة العدّادات',
      'countersTitle': 'العدّادات',
      'newCounter': 'عدّاد جديد',
      'editCounter': 'تعديل العدّاد',
      'counterLabel': 'اسم العدّاد',
      'addCounter': 'إضافة عدّاد',
      'deleteCounter': 'حذف العدّاد',
      'deleteCounterConfirm': 'حذف "{title}"؟ لا يمكن التراجع عن هذا.',
      'noCounters': 'لا توجد عدّادات لهذا اليوم',
      'noCountersYet': 'لا توجد عدّادات بعد',
      'countersTrackPerDay': 'العدّادات تتبع القيم لكل يوم',
      'initialCount': 'القيمة الأولية',
      'manageQuickTasks': 'إدارة المهام السريعة',
      'quickTasksTitle': 'المهام السريعة',
      'newQuickTask': 'مهمة سريعة جديدة',
      'editQuickTask': 'تعديل المهمة السريعة',
      'quickTaskName': 'اسم المهمة',
      'deleteQuickTask': 'حذف المهمة السريعة',
      'noQuickTasksYet': 'لا توجد مهام سريعة بعد',
      'quickTasksAppearOnDate': 'المهام السريعة تظهر في تاريخها المحدد',
      'selectDate': 'اختيار التاريخ',
      'notes': 'الملاحظات',
      'notesTitle': 'الملاحظات',
      'manageNotes': 'الملاحظات',
      'newNote': 'ملاحظة جديدة',
      'editNote': 'تعديل الملاحظة',
      'noteTitle': 'العنوان',
      'noteDescription': 'الوصف',
      'addNote': 'إضافة ملاحظة',
      'deleteNote': 'حذف الملاحظة',
      'deleteNoteConfirm': 'حذف "{title}"؟ لا يمكن التراجع عن هذا.',
      'noNotesYet': 'لا توجد ملاحظات بعد',
      'notesHint': 'احفظ الأشياء التي تريد تذكرها',
      'caloriesTitle': 'السعرات الحرارية',
      'calories': 'السعرات الحرارية',
      'setCalorieGoal': 'تحديد الهدف اليومي',
      'calorieGoalHint': 'هدف السعرات اليومي',
      'cal': 'سعرة',
      'addCalorieEntry': 'إضافة وجبة',
      'foodName': 'اسم الطعام',
      'caloriesAmount': 'السعرات',
      'addEntry': 'إضافة',
      'dailyGoal': 'الهدف اليومي',
      'totalEaten': 'المجموع',
      'difference': 'الفرق',
      'overGoal': 'تجاوزت هدفك، تحتاج حرق المزيد',
      'underGoal': 'تحتاج المزيد من السعرات',
      'exactGoal': 'وصلت لهدفك بالضبط!',
      'noCalorieEntries': 'لا توجد وجبات، اضغط + لإضافة طعام',
      'food': 'طعام',
      'sport': 'رياضة',
      'sportName': 'اسم النشاط',
      'netCalories': 'صافي السعرات',
      'todayWeight': 'وزن اليوم',
      'weight': 'الوزن',
      'weightHint': 'وزنك',
      'kg': 'كغ',
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
  String get counters =>
      _localizedValues[locale.languageCode]!['counters']!;
  String get manageCounters =>
      _localizedValues[locale.languageCode]!['manageCounters']!;
  String get countersTitle =>
      _localizedValues[locale.languageCode]!['countersTitle']!;
  String get newCounter =>
      _localizedValues[locale.languageCode]!['newCounter']!;
  String get editCounter =>
      _localizedValues[locale.languageCode]!['editCounter']!;
  String get counterLabel =>
      _localizedValues[locale.languageCode]!['counterLabel']!;
  String get addCounter =>
      _localizedValues[locale.languageCode]!['addCounter']!;
  String get deleteCounter =>
      _localizedValues[locale.languageCode]!['deleteCounter']!;
  String deleteCounterConfirm(String title) =>
      _localizedValues[locale.languageCode]!['deleteCounterConfirm']!
          .replaceAll('{title}', title);
  String get noCounters =>
      _localizedValues[locale.languageCode]!['noCounters']!;
  String get noCountersYet =>
      _localizedValues[locale.languageCode]!['noCountersYet']!;
  String get countersTrackPerDay =>
      _localizedValues[locale.languageCode]!['countersTrackPerDay']!;
  String get initialCount =>
      _localizedValues[locale.languageCode]!['initialCount']!;
  String get manageQuickTasks =>
      _localizedValues[locale.languageCode]!['manageQuickTasks']!;
  String get quickTasksTitle =>
      _localizedValues[locale.languageCode]!['quickTasksTitle']!;
  String get newQuickTask =>
      _localizedValues[locale.languageCode]!['newQuickTask']!;
  String get editQuickTask =>
      _localizedValues[locale.languageCode]!['editQuickTask']!;
  String get quickTaskName =>
      _localizedValues[locale.languageCode]!['quickTaskName']!;
  String get deleteQuickTask =>
      _localizedValues[locale.languageCode]!['deleteQuickTask']!;
  String get noQuickTasksYet =>
      _localizedValues[locale.languageCode]!['noQuickTasksYet']!;
  String get quickTasksAppearOnDate =>
      _localizedValues[locale.languageCode]!['quickTasksAppearOnDate']!;
  String get selectDate =>
      _localizedValues[locale.languageCode]!['selectDate']!;
  String get notes => _localizedValues[locale.languageCode]!['notes']!;
  String get notesTitle =>
      _localizedValues[locale.languageCode]!['notesTitle']!;
  String get manageNotes =>
      _localizedValues[locale.languageCode]!['manageNotes']!;
  String get newNote => _localizedValues[locale.languageCode]!['newNote']!;
  String get editNote => _localizedValues[locale.languageCode]!['editNote']!;
  String get noteTitle =>
      _localizedValues[locale.languageCode]!['noteTitle']!;
  String get noteDescription =>
      _localizedValues[locale.languageCode]!['noteDescription']!;
  String get addNote => _localizedValues[locale.languageCode]!['addNote']!;
  String get deleteNote =>
      _localizedValues[locale.languageCode]!['deleteNote']!;
  String deleteNoteConfirm(String title) =>
      _localizedValues[locale.languageCode]!['deleteNoteConfirm']!
          .replaceAll('{title}', title);
  String get noNotesYet =>
      _localizedValues[locale.languageCode]!['noNotesYet']!;
  String get notesHint =>
      _localizedValues[locale.languageCode]!['notesHint']!;
  String get caloriesTitle =>
      _localizedValues[locale.languageCode]!['caloriesTitle']!;
  String get calories =>
      _localizedValues[locale.languageCode]!['calories']!;
  String get setCalorieGoal =>
      _localizedValues[locale.languageCode]!['setCalorieGoal']!;
  String get calorieGoalHint =>
      _localizedValues[locale.languageCode]!['calorieGoalHint']!;
  String get cal => _localizedValues[locale.languageCode]!['cal']!;
  String get addCalorieEntry =>
      _localizedValues[locale.languageCode]!['addCalorieEntry']!;
  String get foodName =>
      _localizedValues[locale.languageCode]!['foodName']!;
  String get caloriesAmount =>
      _localizedValues[locale.languageCode]!['caloriesAmount']!;
  String get addEntry =>
      _localizedValues[locale.languageCode]!['addEntry']!;
  String get dailyGoal =>
      _localizedValues[locale.languageCode]!['dailyGoal']!;
  String get totalEaten =>
      _localizedValues[locale.languageCode]!['totalEaten']!;
  String get difference =>
      _localizedValues[locale.languageCode]!['difference']!;
  String get overGoal =>
      _localizedValues[locale.languageCode]!['overGoal']!;
  String get underGoal =>
      _localizedValues[locale.languageCode]!['underGoal']!;
  String get exactGoal =>
      _localizedValues[locale.languageCode]!['exactGoal']!;
  String get noCalorieEntries =>
      _localizedValues[locale.languageCode]!['noCalorieEntries']!;
  String get food => _localizedValues[locale.languageCode]!['food']!;
  String get sport => _localizedValues[locale.languageCode]!['sport']!;
  String get sportName =>
      _localizedValues[locale.languageCode]!['sportName']!;
  String get netCalories =>
      _localizedValues[locale.languageCode]!['netCalories']!;
  String get todayWeight =>
      _localizedValues[locale.languageCode]!['todayWeight']!;
  String get weight => _localizedValues[locale.languageCode]!['weight']!;
  String get weightHint =>
      _localizedValues[locale.languageCode]!['weightHint']!;
  String get kg => _localizedValues[locale.languageCode]!['kg']!;

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
