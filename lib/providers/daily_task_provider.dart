import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/daily_task.dart';
import '../utils/date_helpers.dart';

class DailyTaskProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<DailyTask> _activeTasks = [];   // Active only (for manage screen)
  List<DailyTask> _allTasks = [];      // All including archived (for history)
  List<DailyTask> _tasksForDay = [];   // Ordered tasks for selected day
  Map<int, bool> _completions = {};
  String _selectedDate = DateHelpers.toDateString(DateTime.now());

  /// Active daily tasks only (for the manage screen).
  List<DailyTask> get allTasks => _activeTasks;

  /// Tasks for the selected day, respecting per-day custom order.
  List<DailyTask> get tasksForSelectedDay => _tasksForDay;

  Map<int, bool> get completions => _completions;

  bool isTaskDone(int taskId) => _completions[taskId] ?? false;

  Future<void> loadTasks() async {
    _activeTasks = await _db.getActiveDailyTasks();
    _allTasks = await _db.getAllDailyTasks();
    _completions = await _db.getDailyTaskCompletions(_selectedDate);
    await _buildTasksForDay();
    notifyListeners();
  }

  Future<void> loadCompletionsForDate(String date) async {
    _selectedDate = date;
    _completions = await _db.getDailyTaskCompletions(date);
    await _buildTasksForDay();
    notifyListeners();
  }

  /// Build the ordered task list for the selected day.
  Future<void> _buildTasksForDay() async {
    final date = DateTime.parse(_selectedDate);
    final weekday = date.weekday;

    // Get tasks active on this day and matching weekday
    final filtered = _allTasks
        .where((t) => t.isForWeekday(weekday) && t.wasActiveOn(date))
        .toList();

    // Check if there's a custom order for this date
    final customOrder = await _db.getDayTaskOrder(_selectedDate);
    if (customOrder != null && customOrder.isNotEmpty) {
      // Sort by custom order; tasks not in the order go to the end
      final orderMap = <int, int>{};
      for (int i = 0; i < customOrder.length; i++) {
        orderMap[customOrder[i]] = i;
      }
      filtered.sort((a, b) {
        final orderA = orderMap[a.id] ?? 999999;
        final orderB = orderMap[b.id] ?? 999999;
        return orderA.compareTo(orderB);
      });
    }

    _tasksForDay = filtered;
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
    await _db.archiveDailyTask(id);
    await loadTasks();
  }

  /// Reorder tasks in the manage screen (default order).
  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final task = _activeTasks.removeAt(oldIndex);
    _activeTasks.insert(newIndex, task);
    notifyListeners();
    final orderedIds = _activeTasks.map((t) => t.id!).toList();
    await _db.reorderDailyTasks(orderedIds);
    await loadTasks();
  }

  /// Reorder tasks for a specific day (per-day order on home screen).
  Future<void> reorderTasksForDay(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final task = _tasksForDay.removeAt(oldIndex);
    _tasksForDay.insert(newIndex, task);
    notifyListeners();
    final orderedIds = _tasksForDay.map((t) => t.id!).toList();
    await _db.setDayTaskOrder(_selectedDate, orderedIds);
  }

  Future<void> toggleCompletion(int taskId) async {
    final currentStatus = _completions[taskId] ?? false;
    await _db.toggleDailyTaskCompletion(taskId, _selectedDate, !currentStatus);
    _completions[taskId] = !currentStatus;
    notifyListeners();
  }
}
