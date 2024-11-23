/// {@template injection_exception}
/// An exception used for handling errors related to dependency injection
/// in the application.
///
/// This class implements the [Exception] interface and allows an additional
/// message to be passed that describes the cause of the error when creating
/// an instance of the exception.
///
/// It's used for scenarios where dependency injection fails or encounters
/// an error during execution.
///
/// Example:
/// ```dart
/// throw InjectionException('Error initializing dependency');
/// ```
/// {@endtemplate}
class InjectionException implements Exception {
  /// {@macro injection_exception}
  ///
  /// Constructor that takes a [message] — a string message about the error,
  /// which will be stored in the exception.
  InjectionException(this.message);

  /// {@template message}
  /// The error [message] related to dependency injection.
  ///
  /// This message is available when handling the exception and can be used
  /// for logging or displaying to the user.
  /// {@endtemplate}
  final String message;
}
