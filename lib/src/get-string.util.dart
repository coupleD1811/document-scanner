String getString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  return value.toString();
}

String? getMaybeString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}
