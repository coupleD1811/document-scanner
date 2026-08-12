double getDouble(dynamic value, {double defaultValue = 0}) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return defaultValue;
}

double? getMaybeDouble(dynamic value) {
  if (value is double) {
    return value;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return null;
}
