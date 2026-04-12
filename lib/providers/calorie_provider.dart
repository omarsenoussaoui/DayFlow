import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/calorie_entry.dart';
import '../utils/date_helpers.dart';

class CalorieProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<CalorieEntry> _entries = [];
  int _goal = 2000;
  double? _weight;
  String _selectedDate = DateHelpers.toDateString(DateTime.now());

  List<CalorieEntry> get entries => _entries;
  int get goal => _goal;
  double? get weight => _weight;
  String get selectedDate => _selectedDate;

  /// Food entries only (positive calories)
  int get totalFood =>
      _entries.where((e) => e.calories > 0).fold(0, (sum, e) => sum + e.calories);

  /// Sport/burned entries only (negative calories, returned as positive)
  int get totalBurned =>
      _entries.where((e) => e.calories < 0).fold(0, (sum, e) => sum + e.calories.abs());

  /// Net = food - burned
  int get netCalories =>
      _entries.fold(0, (sum, e) => sum + e.calories);

  /// Positive = over goal (need to lose), negative = under goal (need more)
  int get difference => netCalories - _goal;

  Future<void> loadGoal() async {
    _goal = await _db.getCalorieGoal();
    notifyListeners();
  }

  Future<void> setGoal(int goal) async {
    _goal = goal;
    await _db.setCalorieGoal(goal);
    notifyListeners();
  }

  Future<void> loadEntriesForDate(String date) async {
    _selectedDate = date;
    _entries = await _db.getCalorieEntriesByDate(date);
    _weight = await _db.getWeightForDate(date);
    notifyListeners();
  }

  Future<void> addEntry(String name, int calories) async {
    final entry = CalorieEntry(
      name: name,
      calories: calories,
      date: _selectedDate,
    );
    await _db.insertCalorieEntry(entry);
    await loadEntriesForDate(_selectedDate);
  }

  Future<void> deleteEntry(int id) async {
    await _db.deleteCalorieEntry(id);
    await loadEntriesForDate(_selectedDate);
  }

  Future<void> setWeight(double weight) async {
    _weight = weight;
    await _db.setWeightForDate(_selectedDate, weight);
    notifyListeners();
  }

  void goToDate(DateTime date) {
    loadEntriesForDate(DateHelpers.toDateString(date));
  }
}
