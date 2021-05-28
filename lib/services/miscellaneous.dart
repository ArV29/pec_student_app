import 'package:flutter/cupertino.dart';
import 'package:pec_student/constants.dart';

class MiscellaneousFunctions {
  String readableTime({@required String militaryTime}) {
    int hours = int.parse(militaryTime.substring(0, 2));
    String suffix = 'A.M.';
    if (hours > 12) {
      hours -= 12;
      suffix = 'P.M';
    }
    String h = hours.toString();
    if (hours < 10) {
      h = '0' + h;
    }
    String m = (militaryTime.substring(2));
    String time = h + ':' + m + ' ' + suffix;
    return time;
  }

  Map epochToReadableTime({@required int epoch}) {
    DateTime converted = DateTime.fromMillisecondsSinceEpoch(epoch);
    String date = converted.day.toString() + months[converted.month - 1];
    String hour = converted.hour.toString();
    String minutes = converted.minute.toString();
    if (hour.length == 1) {
      hour = '0' + hour;
    }
    if (minutes.length == 1) {
      minutes = '0' + minutes;
    }
    String time = readableTime(militaryTime: hour + minutes);
    return {'date': date, 'time': time};
  }

  String formattedDate({@required DateTime date}) {
    String data = date.day.toString() +
        ' ' +
        months[date.month - 1] +
        ', ' +
        date.year.toString();
    return data;
  }

  String networkingDateFormat({@required DateTime date}) {
    String month = date.month.toString();
    if (month.length == 1) {
      month = '0' + month;
    }
    String day = date.day.toString();
    if (day.length == 1) {
      day = '0' + month;
    }
    return date.year.toString() + month + day;
  }
}
