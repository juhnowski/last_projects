class Task {
  int id;
  String name;
  String description;
  bool completed;
  DateTime createdAt;
  DateTime deadline;
  int meetingId;

  Task(this.id, this.name, this.description, this.completed, this.createdAt,
      this.deadline, this.meetingId) {
    print('task meetingid: $meetingId');
  }

  static Task fromJson(Map<String, Object> json) {
    return Task(
      json["id"] as int,
      json["name"] as String,
      json["description"] as String,
      json["completed"] as bool,
      DateTime.fromMillisecondsSinceEpoch((json['createdAt'] as int) * 1000)
          .toLocal(),
      DateTime.fromMillisecondsSinceEpoch((json['deadline'] as int) * 1000)
          .toLocal(),
      json["meetingId"] as int,
//      DateTime.parse(json["createdAt"]),
//      DateTime.parse(json["deadline"]),
    );
  }
}
