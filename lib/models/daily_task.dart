class DailyTask {
  final int? id;
  final String title;
  final String days; // Comma-separated day numbers: "1,2,3" (1=Mon, 7=Sun)
  final String createdAt;

  DailyTask({
    this.id,
    required this.title,
    required this.days,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'days': days,
      'created_at': createdAt,
    };
  }

  factory DailyTask.fromMap(Map<String, dynamic> map) {
    return DailyTask(
      id: map['id'] as int,
      title: map['title'] as String,
      days: (map['days'] as String?) ?? '1,2,3,4,5,6,7',
      createdAt: map['created_at'] as String,
    );
  }

  DailyTask copyWith({int? id, String? title, String? days}) {
    return DailyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      days: days ?? this.days,
      createdAt: createdAt,
    );
  }

  /// Returns the list of day numbers this task is assigned to.
  List<int> get dayList =>
      days.split(',').map((d) => int.parse(d.trim())).toList();

  /// Check if this task should appear on a given weekday (1=Mon, 7=Sun).
  bool isForWeekday(int weekday) => dayList.contains(weekday);
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
