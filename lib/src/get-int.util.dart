int getInt(dynamic value, {int defaultValue = 0}) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return defaultValue;
}

int? getMaybeInt(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is double) {
    return value.toInt();
  } else if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
