class CalorieEntry {
  final int? id;
  final String name;
  final int calories;
  final String date;
  final String createdAt;

  CalorieEntry({
    this.id,
    required this.name,
    required this.calories,
    required this.date,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'calories': calories,
      'date': date,
      'created_at': createdAt,
    };
  }

  factory CalorieEntry.fromMap(Map<String, dynamic> map) {
    return CalorieEntry(
      id: map['id'] as int,
      name: map['name'] as String,
      calories: map['calories'] as int,
      date: map['date'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  CalorieEntry copyWith({int? id, String? name, int? calories}) {
    return CalorieEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      date: date,
      createdAt: createdAt,
    );
  }
}

class CalorieGoal {
  final int? id;
  final int goal;

  CalorieGoal({this.id, required this.goal});

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'goal': goal,
    };
  }

  factory CalorieGoal.fromMap(Map<String, dynamic> map) {
    return CalorieGoal(
      id: map['id'] as int,
      goal: map['goal'] as int,
    );
  }
}
