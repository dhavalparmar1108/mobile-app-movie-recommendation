import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';

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
}
