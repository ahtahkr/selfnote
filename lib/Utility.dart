class Utility {

  static String dateTimeHumanReadable(DateTime dateTime) {
    String y = dateTime.year.toString();
    String m = dateTime.month.toString();
    String d = dateTime.day.toString();
    int h = dateTime.hour;
    String min = dateTime.minute.toString();
    String period = 'AM';
    if (h > 12) {
      h = h - 12;
      period = 'PM';
    } else if (h == 0) {
      h = 12;
    }
    return "$y-$m-$d $h:$min $period";
  }
}