/// Password validation matching V1 requirements.
///
/// Rules:
///  - At least 8 characters
///  - At least one letter (A-Z or a-z)
///  - At least one digit (0-9)
///  - At least one special character (@, $, !, %, *, #, ?, &)
class PasswordValidator {
  PasswordValidator._();

  static final _regex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$',
  );

  /// Returns `null` when valid, or an error message when invalid.
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!_regex.hasMatch(value)) {
      return 'Password must be at least 8 characters and include a letter, '
          'a number, and a special character (@\$!%*#?&)';
    }
    return null;
  }
}
