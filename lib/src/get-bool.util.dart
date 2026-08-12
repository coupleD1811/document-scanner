bool getBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) {
    return value;
  } else if (value is num) {
    return value != 0;
  } else if (value is String) {
    const stringifiedTrue = 'true';
    const stringifiedFalse = 'false';
    final standardValue = value.trim().toLowerCase();
    if (standardValue == stringifiedTrue) return true;
    if (standardValue == stringifiedFalse) return false;
  }
  return defaultValue;
}
