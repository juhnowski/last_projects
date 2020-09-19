import 'package:intl/intl.dart';

class TimeUtils {
    static String getFormattedLastMessageTime(date) {
        if (date == null) return '';

        Duration diff = (new DateTime.now()).difference(date);
        if (diff.inMinutes < 1) {
            return 'Сейчас';
        } else if (diff.inMinutes < 5) {
            return '${diff.inMinutes} мин.';
        } else if (diff.inDays < 1) {
            return DateFormat.Hm().format(date);
        } else if (diff.inDays < 365) {
            return (new DateFormat.MMMd("ru_RU")  ).format(date);
        } else {
            return (new DateFormat.yMMMd("ru_RU")  ).format(date);
        }
    }
}