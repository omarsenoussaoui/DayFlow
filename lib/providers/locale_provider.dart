import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _key = 'locale';
  Locale _locale = const Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'ar';
    _locale = code == 'ar'
        ? const Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG')
        : Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final newLocale = isArabic
        ? const Locale('en')
        : const Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG');
    await setLocale(newLocale);
  }
}
