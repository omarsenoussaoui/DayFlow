import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/notification_task.dart';
import '../services/notification_service.dart';

class NotificationTaskProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();

  List<NotificationTask> _allTasks = [];
  List<NotificationTask> _tasksForDate = [];

  List<NotificationTask> get allTasks => _allTasks;
  List<NotificationTask> get tasksForDate => _tasksForDate;

  Future<void> loadAllTasks() async {
    _allTasks = await _db.getAllNotificationTasks();
    notifyListeners();
  }

  Future<void> loadTasksForDate(String date) async {
    _tasksForDate = await _db.getNotificationTasksByDate(date);
    notifyListeners();
  }

  Future<void> addTask(NotificationTask task) async {
    final id = await _db.insertNotificationTask(task);
    final savedTask = task.copyWith(id: id);
    await _notificationService.scheduleNotification(savedTask);
    await loadAllTasks();
  }

  Future<void> updateTask(NotificationTask task) async {
    await _db.updateNotificationTask(task);
    // Cancel old notification and schedule new one
    if (task.id != null) {
      await _notificationService.cancelNotification(task.id!);
      await _notificationService.scheduleNotification(task);
    }
    await loadAllTasks();
  }

  Future<void> deleteTask(int id) async {
    await _notificationService.cancelNotification(id);
    await _db.deleteNotificationTask(id);
    await loadAllTasks();
  }

  Future<void> toggleDone(int id, bool isDone) async {
    await _db.toggleNotificationTaskDone(id, isDone);
    // Update in local lists
    _tasksForDate = _tasksForDate.map((t) {
      if (t.id == id) return t.copyWith(isDone: isDone);
      return t;
    }).toList();
    _allTasks = _allTasks.map((t) {
      if (t.id == id) return t.copyWith(isDone: isDone);
      return t;
    }).toList();
    notifyListeners();
  }
}
