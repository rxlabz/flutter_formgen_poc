String validateRequired(dynamic value) {
  if (value == null) return 'Required';
  if ((value is Map || value is List || value is String) && value.isEmpty)
    return 'Required';
  return null;
}

String validateMail(String value) =>
    RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)")
            .hasMatch(value)
        ? null
        : 'Invalid email';
