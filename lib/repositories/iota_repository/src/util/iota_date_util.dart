import 'package:intl/intl.dart';

class IotaDateUtil{
  static DateTime? dateFromJson(String? dateString) {
    if (dateString != null) {
      final dateFormat = DateFormat("dd MMMM, yyyy h:mm");
      final dateTime = dateFormat.parse(dateString);
      return dateTime;
    } else {
      return null;
    }
  }

  static String? dateToJson(DateTime? time) {
    if (time != null) {
      return DateFormat("dd MMMM, yyyy h:mm").format(time);
    } else {
      return null;
    }
  }
}