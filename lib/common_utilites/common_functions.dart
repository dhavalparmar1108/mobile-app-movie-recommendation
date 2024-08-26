import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CommonFunctions
{
  showToast(String msg)
  {
    Fluttertoast.showToast(msg: msg,);
  }

  static printLog(String msg)
  {
    log(msg);
  }

  static printErrorLog(String msg)
  {
    log("Error : " + msg);
  }

  String convertMinutesToHours(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    return '${hours}h ${remainingMinutes}m';
  }

  String amountFormatter(int amount)
  {
    if(amount == 0)
      {
        return "-";
      }
    String formattedAmount = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
        decimalDigits: 0
    ).format(amount);
    return formattedAmount;
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    int day = date.day;
    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }
    String formattedDate = DateFormat("d'${suffix}' MMMM, y").format(date);
    return formattedDate;
  }

}
