class Habit {
  String title;
  DateTime? reminderTime;
  bool isCompleted;

  Habit({
    required this.title,
    this.reminderTime,
    this.isCompleted = false,
  });
}
