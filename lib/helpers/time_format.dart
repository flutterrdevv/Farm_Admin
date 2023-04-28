import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inDays > 0) {
    return DateFormat.yMd().format(dateTime);
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hr';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} min';
  } else {
    return 'Just now';
  }
}
