import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class GlobalFunctions{
  String formattedDate(DateTime date) {
    return formatter.format(date);
  }
}