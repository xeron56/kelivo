import 'dart:convert';

class CompanionTask {
  CompanionTask({
    required this.id,
    required this.text,
    required this.createdAt,
    this.completed = false,
  });

  factory CompanionTask.fromJson(Map<String, dynamic> json) => CompanionTask(
        id: json['id'] as String,
        text: json['text'] as String,
        completed: json['completed'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String text;
  bool completed;
  final DateTime createdAt;

  CompanionTask copyWith({String? text, bool? completed}) => CompanionTask(
        id: id,
        text: text ?? this.text,
        completed: completed ?? this.completed,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'completed': completed,
        'createdAt': createdAt.toIso8601String(),
      };

  static List<CompanionTask> listFromJson(String raw) {
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(CompanionTask.fromJson)
          .toList();
    } catch (_) {
      return <CompanionTask>[];
    }
  }

  static String listToJson(List<CompanionTask> tasks) =>
      jsonEncode(tasks.map((t) => t.toJson()).toList());
}
