import 'package:intl/intl.dart';

const _easternArabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Replace Eastern Arabic (Hindi) numerals with Western Arabic numerals.
String _westernize(String input) {
  var result = input;
  for (int i = 0; i < _easternArabicDigits.length; i++) {
    result = result.replaceAll(_easternArabicDigits[i], '$i');
  }
  return result;
}

class DateHelpers {
  static String formatDateFull(DateTime date, [String locale = 'en']) {
    final formatted = DateFormat('EEEE, MMMM d, yyyy', locale).format(date);
    return locale == 'ar' ? _westernize(formatted) : formatted;
  }

  static String formatDateShort(DateTime date, [String locale = 'en']) {
    final formatted = DateFormat('MMM d, yyyy', locale).format(date);
    return locale == 'ar' ? _westernize(formatted) : formatted;
  }

  static String toDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String formatTimeFromString(String time) {
    return time; // Already in HH:mm
  }

  static List<DateTime> getCurrentWeekDates(DateTime selectedDate) {
    // Show 3 days before and 3 days after selected date
    final List<DateTime> dates = [];
    for (int i = -3; i <= 3; i++) {
      dates.add(selectedDate.add(Duration(days: i)));
    }
    return dates;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String dayOfWeekShort(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  static String dayNumber(DateTime date) {
    return DateFormat('d').format(date);
  }
}
