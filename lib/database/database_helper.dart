import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/calorie_entry.dart';
import '../models/counter.dart';
import '../models/daily_task.dart';
import '../models/note.dart';
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
      version: 10,
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
        sort_order INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        archived_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_task_day_order (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        task_ids TEXT NOT NULL
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

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE calorie_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE calorie_goal (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal INTEGER NOT NULL DEFAULT 2000
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_weight (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        weight REAL NOT NULL
      )
    ''');

    // Create indexes for common queries
    await db.execute(
      'CREATE INDEX idx_calorie_date ON calorie_entries(date)',
    );
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
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT NOT NULL DEFAULT '',
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE calorie_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          calories INTEGER NOT NULL,
          date TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE calorie_goal (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          goal INTEGER NOT NULL DEFAULT 2000
        )
      ''');
      await db.execute(
        'CREATE INDEX idx_calorie_date ON calorie_entries(date)',
      );
    }
    if (oldVersion < 7) {
      await db.execute('''
        CREATE TABLE daily_weight (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          weight REAL NOT NULL
        )
      ''');
    }
    if (oldVersion < 8) {
      await db.execute(
        'ALTER TABLE daily_tasks ADD COLUMN archived_at TEXT',
      );
    }
    if (oldVersion < 9) {
      await db.execute(
        'ALTER TABLE daily_tasks ADD COLUMN sort_order INTEGER NOT NULL DEFAULT 0',
      );
    }
    if (oldVersion < 10) {
      await db.execute('''
        CREATE TABLE daily_task_day_order (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          task_ids TEXT NOT NULL
        )
      ''');
    }
  }

  // --- Daily Tasks ---

  Future<int> insertDailyTask(DailyTask task) async {
    final db = await database;
    return await db.insert('daily_tasks', task.toMap());
  }

  /// Returns only active (non-archived) daily tasks — for the manage screen.
  Future<List<DailyTask>> getActiveDailyTasks() async {
    final db = await database;
    final maps = await db.query(
      'daily_tasks',
      where: 'archived_at IS NULL',
      orderBy: 'sort_order ASC, created_at ASC',
    );
    return maps.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// Returns ALL daily tasks (active + archived) — for historical views.
  Future<List<DailyTask>> getAllDailyTasks() async {
    final db = await database;
    final maps = await db.query('daily_tasks', orderBy: 'sort_order ASC, created_at ASC');
    return maps.map((map) => DailyTask.fromMap(map)).toList();
  }

  /// Update sort_order for a list of task IDs.
  Future<void> reorderDailyTasks(List<int> orderedIds) async {
    final db = await database;
    final batch = db.batch();
    for (int i = 0; i < orderedIds.length; i++) {
      batch.update(
        'daily_tasks',
        {'sort_order': i},
        where: 'id = ?',
        whereArgs: [orderedIds[i]],
      );
    }
    await batch.commit(noResult: true);
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

  /// Soft-delete: archives the task so it stops appearing in the active list
  /// but remains in history for past dates.
  Future<int> archiveDailyTask(int id) async {
    final db = await database;
    return await db.update(
      'daily_tasks',
      {'archived_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Daily Task Day Order ---

  /// Get the custom task order for a specific date. Returns null if no custom order.
  Future<List<int>?> getDayTaskOrder(String date) async {
    final db = await database;
    final maps = await db.query(
      'daily_task_day_order',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final idsStr = maps.first['task_ids'] as String;
    if (idsStr.isEmpty) return null;
    return idsStr.split(',').map((s) => int.parse(s.trim())).toList();
  }

  /// Save a custom task order for a specific date.
  Future<void> setDayTaskOrder(String date, List<int> taskIds) async {
    final db = await database;
    final idsStr = taskIds.join(',');
    final maps = await db.query(
      'daily_task_day_order',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) {
      await db.insert('daily_task_day_order', {
        'date': date,
        'task_ids': idsStr,
      });
    } else {
      await db.update(
        'daily_task_day_order',
        {'task_ids': idsStr},
        where: 'date = ?',
        whereArgs: [date],
      );
    }
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

  // --- Notes ---

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'updated_at DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // --- Calorie Entries ---

  Future<int> insertCalorieEntry(CalorieEntry entry) async {
    final db = await database;
    return await db.insert('calorie_entries', entry.toMap());
  }

  Future<List<CalorieEntry>> getCalorieEntriesByDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'calorie_entries',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => CalorieEntry.fromMap(map)).toList();
  }

  Future<int> deleteCalorieEntry(int id) async {
    final db = await database;
    return await db.delete('calorie_entries', where: 'id = ?', whereArgs: [id]);
  }

  // --- Calorie Goal ---

  Future<int> getCalorieGoal() async {
    final db = await database;
    final maps = await db.query('calorie_goal', limit: 1);
    if (maps.isEmpty) {
      await db.insert('calorie_goal', {'goal': 2000});
      return 2000;
    }
    return maps.first['goal'] as int;
  }

  Future<void> setCalorieGoal(int goal) async {
    final db = await database;
    final maps = await db.query('calorie_goal', limit: 1);
    if (maps.isEmpty) {
      await db.insert('calorie_goal', {'goal': goal});
    } else {
      await db.update(
        'calorie_goal',
        {'goal': goal},
        where: 'id = ?',
        whereArgs: [maps.first['id']],
      );
    }
  }

  // --- Daily Weight ---

  Future<double?> getWeightForDate(String date) async {
    final db = await database;
    final maps = await db.query(
      'daily_weight',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return maps.first['weight'] as double;
  }

  Future<void> setWeightForDate(String date, double weight) async {
    final db = await database;
    final maps = await db.query(
      'daily_weight',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    if (maps.isEmpty) {
      await db.insert('daily_weight', {'date': date, 'weight': weight});
    } else {
      await db.update(
        'daily_weight',
        {'weight': weight},
        where: 'date = ?',
        whereArgs: [date],
      );
    }
  }
}
