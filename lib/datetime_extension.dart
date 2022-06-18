import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  String get saveDatetimeFormat {
    final DateFormat formatter = DateFormat("yyyy-MM-dd H:m:s");
    return formatter.format(this);
  }
}
