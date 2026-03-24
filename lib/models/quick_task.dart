class QuickTask {
  final int? id;
  final String title;
  final String date;
  final bool isDone;
  final String createdAt;

  QuickTask({
    this.id,
    required this.title,
    required this.date,
    this.isDone = false,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'date': date,
      'is_done': isDone ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory QuickTask.fromMap(Map<String, dynamic> map) {
    return QuickTask(
      id: map['id'] as int,
      title: map['title'] as String,
      date: map['date'] as String,
      isDone: (map['is_done'] as int) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  QuickTask copyWith({int? id, String? title, String? date, bool? isDone}) {
    return QuickTask(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }
}
