class NotificationTask {
  final int? id;
  final String title;
  final String date;
  final String time;
  final bool isDone;
  final String createdAt;

  NotificationTask({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    this.isDone = false,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'date': date,
      'time': time,
      'is_done': isDone ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory NotificationTask.fromMap(Map<String, dynamic> map) {
    return NotificationTask(
      id: map['id'] as int,
      title: map['title'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      isDone: (map['is_done'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  NotificationTask copyWith({
    int? id,
    String? title,
    String? date,
    String? time,
    bool? isDone,
  }) {
    return NotificationTask(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }

  DateTime get scheduledDateTime {
    final parts = time.split(':');
    final dateParts = date.split('-');
    return DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
