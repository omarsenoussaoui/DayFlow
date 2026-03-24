import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/quick_task.dart';

class QuickTaskProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<QuickTask> _tasks = [];
  List<QuickTask> _allTasks = [];

  List<QuickTask> get tasks => _tasks;
  List<QuickTask> get allTasks => _allTasks;

  Future<void> loadAllTasks() async {
    _allTasks = await _db.getAllQuickTasks();
    notifyListeners();
  }

  Future<void> loadTasksForDate(String date) async {
    _tasks = await _db.getQuickTasksByDate(date);
    notifyListeners();
  }

  Future<void> addTask(String title, String date) async {
    final task = QuickTask(title: title, date: date);
    await _db.insertQuickTask(task);
    await loadTasksForDate(date);
  }

  Future<void> updateTask(QuickTask task, String date) async {
    await _db.updateQuickTask(task);
    await loadAllTasks();
    await loadTasksForDate(date);
  }

  Future<void> deleteTask(int id, String date) async {
    await _db.deleteQuickTask(id);
    await loadTasksForDate(date);
  }

  Future<void> toggleDone(int id, bool isDone, String date) async {
    await _db.toggleQuickTaskDone(id, isDone);
    _tasks = _tasks.map((t) {
      if (t.id == id) return t.copyWith(isDone: isDone);
      return t;
    }).toList();
    notifyListeners();
  }
}
