class Counter {
  final int? id;
  final String label;
  final int count;
  final String createdAt;

  Counter({
    this.id,
    required this.label,
    this.count = 0,
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'label': label,
      'count': count,
      'created_at': createdAt,
    };
  }

  factory Counter.fromMap(Map<String, dynamic> map) {
    return Counter(
      id: map['id'] as int,
      label: map['label'] as String,
      count: map['count'] as int,
      createdAt: map['created_at'] as String,
    );
  }

  Counter copyWith({int? id, String? label, int? count}) {
    return Counter(
      id: id ?? this.id,
      label: label ?? this.label,
      count: count ?? this.count,
      createdAt: createdAt,
    );
  }
}
