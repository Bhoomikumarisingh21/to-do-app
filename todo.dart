import 'dart:convert';

enum Priority { low, medium, high }

class Todo {
  final String id;
  String title;
  String description;
  bool isCompleted;
  Priority priority;
  DateTime createdAt;
  DateTime? dueDate;
  String category;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.priority = Priority.medium,
    required this.createdAt,
    this.dueDate,
    this.category = 'General',
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    Priority? priority,
    DateTime? createdAt,
    DateTime? dueDate,
    String? category,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'category': category,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      priority: Priority.values[map['priority'] ?? 1],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      category: map['category'] ?? 'General',
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
