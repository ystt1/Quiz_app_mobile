import 'package:intl/intl.dart';

class AppHelper{
  static String timeAgo(String dateString) {
    try {
      DateTime inputDate = DateTime.parse(dateString).toLocal();
      DateTime now = DateTime.now();
      Duration difference = now.difference(inputDate);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} seconds ago';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return DateFormat('dd/MM/yyyy').format(inputDate);
      }
    }
    catch( e)
    {
      return dateString;
    }
  }



  static dateFormatWithTime(String isoDate)
  {
    DateTime dateTime = DateTime.parse(isoDate);

    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    return formattedDate;
  }

  static dateFormat(String isoDate)
  {
    DateTime dateTime = DateTime.parse(isoDate);

    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  static String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes min $secs second';
  }
}