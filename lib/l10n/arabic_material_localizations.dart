import 'package:flutter/material.dart';

/// Custom Arabic MaterialLocalizations that uses Western Arabic numerals (1,2,3)
/// instead of Eastern Arabic/Hindi numerals (١,٢,٣).
class ArabicWesternMaterialLocalizations extends DefaultMaterialLocalizations {
  const ArabicWesternMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _ArabicWesternMaterialLocalizationsDelegate();

  static const _easternDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String _westernize(String input) {
    var result = input;
    for (int i = 0; i < _easternDigits.length; i++) {
      result = result.replaceAll(_easternDigits[i], '$i');
    }
    return result;
  }

  @override
  String formatDecimal(int number) {
    return _westernize(super.formatDecimal(number));
  }

  @override
  String formatCompactDate(DateTime date) {
    return _westernize(super.formatCompactDate(date));
  }

  @override
  String formatFullDate(DateTime date) {
    return _westernize(super.formatFullDate(date));
  }

  @override
  String formatMediumDate(DateTime date) {
    return _westernize(super.formatMediumDate(date));
  }

  @override
  String formatShortDate(DateTime date) {
    return _westernize(super.formatShortDate(date));
  }

  @override
  String formatShortMonthDay(DateTime date) {
    return _westernize(super.formatShortMonthDay(date));
  }

  @override
  String formatYear(DateTime date) {
    return _westernize(super.formatYear(date));
  }

  @override
  String formatMonthYear(DateTime date) {
    return _westernize(super.formatMonthYear(date));
  }

  @override
  String formatTimeOfDay(TimeOfDay timeOfDay, {bool alwaysUse24HourFormat = false}) {
    return _westernize(super.formatTimeOfDay(timeOfDay, alwaysUse24HourFormat: alwaysUse24HourFormat));
  }

  @override
  String get dateInputLabel => 'أدخل التاريخ';

  @override
  String get dateRangePickerHelpText => 'اختر النطاق';

  @override
  String get dateHelpText => 'يوم/شهر/سنة';

  @override
  String get calendarModeButtonLabel => 'التبديل إلى التقويم';

  @override
  String get inputDateModeButtonLabel => 'التبديل إلى الإدخال';

  @override
  String get saveButtonLabel => 'حفظ';

  @override
  String get cancelButtonLabel => 'إلغاء';

  @override
  String get closeButtonLabel => 'إغلاق';

  @override
  String get okButtonLabel => 'موافق';

  @override
  String get deleteButtonTooltip => 'حذف';

  @override
  String get nextMonthTooltip => 'الشهر التالي';

  @override
  String get previousMonthTooltip => 'الشهر السابق';

  @override
  String get nextPageTooltip => 'الصفحة التالية';

  @override
  String get previousPageTooltip => 'الصفحة السابقة';

  @override
  String get firstPageTooltip => 'الصفحة الأولى';

  @override
  String get lastPageTooltip => 'الصفحة الأخيرة';

  @override
  String get showMenuTooltip => 'عرض القائمة';

  @override
  String get searchFieldLabel => 'بحث';

  @override
  String get selectAllButtonLabel => 'تحديد الكل';

  @override
  String get copyButtonLabel => 'نسخ';

  @override
  String get cutButtonLabel => 'قص';

  @override
  String get pasteButtonLabel => 'لصق';

  @override
  String get moreButtonTooltip => 'المزيد';

  @override
  String get dialogLabel => 'مربع حوار';

  @override
  String get alertDialogLabel => 'تنبيه';

  @override
  String get datePickerHelpText => 'اختر التاريخ';

  @override
  String get timePickerDialHelpText => 'اختر الوقت';

  @override
  String get timePickerInputHelpText => 'أدخل الوقت';

  @override
  String get modalBarrierDismissLabel => 'إغلاق';

  @override
  String get signedInLabel => 'تم تسجيل الدخول';

  @override
  String get hideAccountsLabel => 'إخفاء الحسابات';

  @override
  String get showAccountsLabel => 'عرض الحسابات';

  @override
  String get drawerLabel => 'قائمة التنقل';

  @override
  String get popupMenuLabel => 'القائمة المنبثقة';

  @override
  String get menuBarMenuLabel => 'قائمة شريط القوائم';

  @override
  String get bottomSheetLabel => 'ورقة سفلية';

  @override
  String get expandedIconTapHint => 'طي';

  @override
  String get collapsedIconTapHint => 'توسيع';

  @override
  String get keyboardKeyChannelUp => 'القناة السابقة';

  @override
  String get keyboardKeyChannelDown => 'القناة التالية';

  @override
  ScriptCategory get scriptCategory => ScriptCategory.tall;

  @override
  String selectedRowCountTitle(int selectedRowCount) {
    if (selectedRowCount == 0) return 'لم يتم تحديد أي عنصر';
    if (selectedRowCount == 1) return 'تم تحديد عنصر واحد';
    return 'تم تحديد $selectedRowCount عنصر';
  }

  @override
  String pageRowsInfoTitle(int firstRow, int lastRow, int rowCount, bool rowCountIsApproximate) {
    return '$firstRow–$lastRow من $rowCount';
  }

  @override
  String aboutListTileTitle(String applicationName) {
    return 'حول $applicationName';
  }

  @override
  String tabLabel({required int tabIndex, required int tabCount}) {
    return 'علامة التبويب $tabIndex من $tabCount';
  }

  @override
  String remainingTextFieldCharacterCount(int remaining) {
    if (remaining == 0) return 'لم يتبق أي حرف';
    if (remaining == 1) return 'حرف واحد متبقٍ';
    return '$remaining حرف متبقٍ';
  }

  @override
  TimeOfDayFormat timeOfDayFormat({bool alwaysUse24HourFormat = false}) {
    return alwaysUse24HourFormat ? TimeOfDayFormat.HH_colon_mm : TimeOfDayFormat.h_colon_mm_space_a;
  }
}

class _ArabicWesternMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _ArabicWesternMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const ArabicWesternMaterialLocalizations();
  }

  @override
  bool shouldReload(_ArabicWesternMaterialLocalizationsDelegate old) => false;
}
