class Task {
  int? id;
  int userId;
  String title;
  String? description;
  bool isCompleted;

  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      userId: map['userId'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
