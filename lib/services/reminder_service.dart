class ReminderService {

  static List<String> reminders = [];

  static void addReminder({
    required String title,
    required String date,
    required String time,
  }) {
//  حساب الوقت المتبقي حتى بدء الحدث
    try {
      DateTime eventDateTime = DateTime.parse("$date $time");
      DateTime now = DateTime.now();

      Duration difference = eventDateTime.difference(now);

      String message;

      if (difference.inHours <= 0) {
        message = "$title is happening now";
      } else if (difference.inHours < 24) {
        message = "$title starts in ${difference.inHours} hours";
      } else {
        int days = difference.inDays;
        message = "$title starts in $days day(s)";
      }

      // منع التكرار
      if (!reminders.contains(message)) {
        reminders.add(message);
      }

    } catch (e) {
      if (!reminders.contains(title)) {
        reminders.add("$title starts soon");
      }
    }
  }

  static List<String> getReminders() {
    return reminders;
  }
}