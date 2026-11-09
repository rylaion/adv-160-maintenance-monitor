/// An error whose [message] is safe and useful to show to the user
/// (validation failures and rule violations).
abstract interface class UserFacingException implements Exception {
  String get message;
}
