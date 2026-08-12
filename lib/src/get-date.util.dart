import 'package:intl/intl.dart';

DateTime? _tryParse(String value, {DateFormat? dateFormat}) {
  if (dateFormat != null) {
    return dateFormat.tryParse(value);
  }
  return DateTime.tryParse(value);
}

DateTime getDate(
  dynamic value, {
  DateFormat? dateFormat,
  DateTime? defaultValue,
}) {
  defaultValue ??= DateTime(1990);
  if (value is DateTime) {
    return value.toLocal();
  } else if (value is String) {
    final parsedValue = _tryParse(value, dateFormat: dateFormat);
    if (parsedValue != null) {
      return parsedValue.toLocal();
    }
  }
  return defaultValue;
}

DateTime? getMaybeDate(dynamic value, {DateFormat? dateFormat}) {
  if (value is DateTime) {
    return value.toLocal();
  } else if (value is String) {
    final parsedValue = _tryParse(value, dateFormat: dateFormat);
    if (parsedValue != null) {
      return parsedValue.toLocal();
    }
  }
  return null;
}

String? dateToString(dynamic value, {DateFormat? dateFormat}) {
  switch (value) {
    case String():
      return value;
    case DateTime():
      if (dateFormat != null) {
        return dateFormat.format(value.toUtc());
      }
      return value.toUtc().toIso8601String();
    default:
      return null;
  }
}
