enum TaskStatus {
  pending,
  complete,
}

extension TaskStatusExtension on TaskStatus {
  TaskStatus toggle() {
    switch (this) {
      case TaskStatus.pending:
        return TaskStatus.complete;
      case TaskStatus.complete:
        return TaskStatus.pending;
    }
  }

  static TaskStatus fromString(String string) {
    for (var element in TaskStatus.values) {
      if (element.toString() == string) {
        return element;
      }
    }

    throw Exception("Invalid TaskStatus");
  }
}

class Task {
  String uuid;
  TaskStatus status;
  String description;
  DateTime? due;
  List<String> tags;
  String? imagePath;

  Task({
    required this.uuid,
    required this.description,
    required this.due,
    required this.tags,
    this.status = TaskStatus.pending,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'status': status.toString(),
      'description': description,
      'due': due?.toIso8601String(),
      'tags': tags.join(","),
      'imagePath': imagePath ?? "",
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      uuid: json['uuid'],
      status: TaskStatusExtension.fromString(json['status']),
      description: json['description'],
      due: (json["due"] != null) ? DateTime.parse(json["due"]) : null,
      tags: (json['tags'] as String)
          .split(',')
          .where((e) => e.isNotEmpty)
          .toList(),
      imagePath:
          (json["imagePath"] as String).isNotEmpty ? json["imagePath"] : null,
    );
  }
}
