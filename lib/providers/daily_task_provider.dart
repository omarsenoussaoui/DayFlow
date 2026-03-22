import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/daily_task.dart';
import '../utils/date_helpers.dart';

class DailyTaskProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<DailyTask> _allTasks = [];
  Map<int, bool> _completions = {};
  String _selectedDate = DateHelpers.toDateString(DateTime.now());

  /// All daily tasks (for the manage screen).
  List<DailyTask> get allTasks => _allTasks;

  /// Tasks filtered by the selected date's weekday (for the home screen).
  List<DailyTask> get tasksForSelectedDay {
    final date = DateTime.parse(_selectedDate);
    final weekday = date.weekday; // 1=Mon, 7=Sun
    return _allTasks.where((t) => t.isForWeekday(weekday)).toList();
  }

  Map<int, bool> get completions => _completions;

  bool isTaskDone(int taskId) => _completions[taskId] ?? false;

  Future<void> loadTasks() async {
    _allTasks = await _db.getAllDailyTasks();
    _completions = await _db.getDailyTaskCompletions(_selectedDate);
    notifyListeners();
  }

  Future<void> loadCompletionsForDate(String date) async {
    _selectedDate = date;
    _completions = await _db.getDailyTaskCompletions(date);
    notifyListeners();
  }

  Future<void> addTask(String title, String days) async {
    final task = DailyTask(title: title, days: days);
    await _db.insertDailyTask(task);
    await loadTasks();
  }

  Future<void> updateTask(DailyTask task) async {
    await _db.updateDailyTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteDailyTask(id);
    await loadTasks();
  }

  Future<void> toggleCompletion(int taskId) async {
    final currentStatus = _completions[taskId] ?? false;
    await _db.toggleDailyTaskCompletion(taskId, _selectedDate, !currentStatus);
    _completions[taskId] = !currentStatus;
    notifyListeners();
  }
}
