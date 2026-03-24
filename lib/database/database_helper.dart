import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/counter.dart';
import '../models/daily_task.dart';
import '../models/notification_task.dart';
import '../models/quick_task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dayflow.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE daily_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        days TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_task_completions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        daily_task_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (daily_task_id) REFERENCES daily_tasks(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE notification_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE quick_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        is_done INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE counters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT NOT NULL,
        count INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Create indexes for common queries
    await db.execute(
      'CREATE INDEX idx_completions_task_date ON daily_task_completions(daily_task_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_notification_date ON notification_tasks(date)',
    );
    await db.execute(
      'CREATE INDEX idx_quick_date ON quick_tasks(date)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE daily_tasks ADD COLUMN days TEXT NOT NULL DEFAULT '1,2,3,4,5,6,7'",
      );
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE counters (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          label TEXT NOT NULL,
          count INTEGER NOT NULL DEFAULT 0,
          date TEXT NOT NULL DEFAULT '',
          created_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      // Recreate counters table without date column
      await db.execute('DROP TABLE IF EXISTS counters');
      await db.execute('''
        CREATE TABLE counters (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          label TEXT NOT NULL,
          count INTEGER NOT NULL DEFAULT 0,
          created_at TEXT NOT NULL
        )
      ''');
    }
  }

  // --- Daily Tasks ---

  Future<int> insertDailyTask(DailyTask task) async {
    final db = await database;
    return await db.insert('daily_tasks', task.toMap());
  }

  Future<List<DailyTask>> getAllDailyTasks() async {
    final db = await database;
    final maps = await db.query('daily_tasks', orderBy: 'created_at ASC');
    return maps.map((map) => DailyTask.fromMap(map)).toList();
  }

  Future<int> updateDailyTask(DailyTask task) async {
    final db = await database;
    return await db.update(
      'daily_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteDailyTask(int id) async {
    final db = await database;
    // Also delete completions
    await db.delete('daily_task_completions',
        where: 'daily_task_id = ?', whereArgs: [id]);
    return await db.delete('daily_tasks', where: 'id = ?', whereArgs: [id]);
  }

  // --- Daily Task Completions ---

  Future<void> toggleDailyTaskCompletion(
      int dailyTaskId, String date, bool isDone) async {
    final db = await database;
    final existing = await db.query(
      'daily_task_completions',
      where: 'daily_task_id = ? AND date = ?',
      whereArgs: [dailyTaskId, date],
    );

    if (existing.isEmpty) {
      await db.insert('daily_task_completions', {
        'daily_task_id': dailyTaskId,
        'date': date,
        'is_done': isDone ? 1 : 0,
      });
    } else {
      await db.update(
        'daily_task_completions',
        {'is_done': isDone ? 1 : 0},
        where: 'daily_task_id = ? AND date = ?',
        whereArgs: [dailyTaskId, date],
      );
    }
  }

  Future<Map<int, bool>> getDailyTaskCompletions(String date) async {
    final db = await database;
    final maps = await db.query(
      'daily_task_completions',
      where: 'date = ?',
      whereArgs: [date],
    );
    final result = <int, bool>{};
    for (final map in maps) {
      result[map['daily_task_id'] as int] = (map['is_done'] as int) == 1;
    }
    return result;
  }

  // --- Notification Tasks ---

  Future<int> insertNotificationTask(NotificationTask task) async {
    final db = await database;
    return await db.insert('notification_tasks', task.toMap());
  }

  Future<List<NotificationTask>> getAllNotificationTasks() async {
    final db = await database;
    final maps = await db.query('notification_tasks', orderBy: 'date ASC, time ASC');
    return maps.map((map) => NotificationTask.fromMap(map)).toList();
  }

  Future<List<NotificationTask>> getNotificationTasksByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'notification_tasks',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'time ASC',
    );
    return maps.map((map) => NotificationTask.fromMap(map)).toList();
  }

  Future<int> updateNotificationTask(NotificationTask task) async {
    final db = await database;
    return await db.update(
      'notification_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteNotificationTask(int id) async {
    final db = await database;
    return await db.delete('notification_tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleNotificationTaskDone(int id, bool isDone) async {
    final db = await database;
    await db.update(
      'notification_tasks',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Quick Tasks ---

  Future<int> insertQuickTask(QuickTask task) async {
    final db = await database;
    return await db.insert('quick_tasks', task.toMap());
  }

  Future<List<QuickTask>> getAllQuickTasks() async {
    final db = await database;
    final maps = await db.query('quick_tasks', orderBy: 'date ASC, created_at ASC');
    return maps.map((map) => QuickTask.fromMap(map)).toList();
  }

  Future<List<QuickTask>> getQuickTasksByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'quick_tasks',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => QuickTask.fromMap(map)).toList();
  }

  Future<int> updateQuickTask(QuickTask task) async {
    final db = await database;
    return await db.update(
      'quick_tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteQuickTask(int id) async {
    final db = await database;
    return await db.delete('quick_tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleQuickTaskDone(int id, bool isDone) async {
    final db = await database;
    await db.update(
      'quick_tasks',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Counters ---

  Future<int> insertCounter(Counter counter) async {
    final db = await database;
    return await db.insert('counters', counter.toMap());
  }

  Future<List<Counter>> getAllCounters() async {
    final db = await database;
    final maps = await db.query('counters', orderBy: 'created_at ASC');
    return maps.map((map) => Counter.fromMap(map)).toList();
  }

  Future<int> updateCounter(Counter counter) async {
    final db = await database;
    return await db.update(
      'counters',
      counter.toMap(),
      where: 'id = ?',
      whereArgs: [counter.id],
    );
  }

  Future<int> deleteCounter(int id) async {
    final db = await database;
    return await db.delete('counters', where: 'id = ?', whereArgs: [id]);
  }
}
