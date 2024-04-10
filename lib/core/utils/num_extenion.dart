import 'package:intl/intl.dart';

extension NumExtension on num {
  String toFormattedString() {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(this);
  }
}
