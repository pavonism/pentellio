import 'package:intl/intl.dart';

extension NumberParsing on DateTime {
  String time() {
    return DateFormat(DateFormat.HOUR24_MINUTE).format(this);
  }

  String date() {
    return DateFormat(DateFormat.YEAR_MONTH_DAY).format(this);
  }

  DateTime today() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String timeAgo() {
    if (isBefore(today())) {
      return date();
    } else {
      return time();
    }
  }
  // ···
}
