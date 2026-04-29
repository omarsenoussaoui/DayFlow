class DailyTask {
  final int? id;
  final String title;
  final String days; // Comma-separated day numbers: "1,2,3" (1=Mon, 7=Sun)
  final int sortOrder;
  final String createdAt;
  final String? archivedAt; // null = active, set = archived (soft-deleted)

  DailyTask({
    this.id,
    required this.title,
    required this.days,
    this.sortOrder = 0,
    String? createdAt,
    this.archivedAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  bool get isActive => archivedAt == null;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'days': days,
      'sort_order': sortOrder,
      'created_at': createdAt,
      'archived_at': archivedAt,
    };
  }

  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] as int,
      title: map['title'] as String,
      days: (map['days'] as String?) ?? '1,2,3,4,5,6,7',
      sortOrder: (map['sort_order'] as int?) ?? 0,
      createdAt: map['created_at'] as String,
      archivedAt: map['archived_at'] as String?,
    );
  }

  DailyTask copyWith({int? id, String? title, String? days, int? sortOrder, String? archivedAt}) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      days: days ?? this.days,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }

  /// Returns the list of day numbers this task is assigned to.
  List<int> get dayList =>
      days.split(',').map((d) => int.parse(d.trim())).toList();

  /// Check if this task should appear on a given weekday (1=Mon, 7=Sun).
  bool isForWeekday(int weekday) => dayList.contains(weekday);

  /// Check if this task was active on a given date.
  bool wasActiveOn(DateTime date) {
    final created = DateTime.parse(createdAt);
    // Task must have been created on or before the date
    if (DateTime(created.year, created.month, created.day)
            .isAfter(DateTime(date.year, date.month, date.day))) {
      return false;
    }
    // If archived, it must have been archived after the date
    if (archivedAt != null) {
      final archived = DateTime.parse(archivedAt!);
      if (DateTime(archived.year, archived.month, archived.day)
              .isBefore(DateTime(date.year, date.month, date.day))) {
        return false;
      }
    }
    return true;
  }
}

class DailyTaskCompletion {
  final int? id;
  final int dailyTaskId;
  final String date;
  final bool isDone;

  DailyTaskCompletion({
    this.id,
    required this.dailyTaskId,
    required this.date,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'daily_task_id': dailyTaskId,
      'date': date,
      'is_done': isDone ? 1 : 0,
    };
  }

  factory DailyTaskCompletion.fromMap(Map<String, dynamic> map) {
    return DailyTaskCompletion(
      id: map['id'] as int,
      dailyTaskId: map['daily_task_id'] as int,
      date: map['date'] as String,
      isDone: (map['is_done'] as int) == 1,
    );
  }
}
