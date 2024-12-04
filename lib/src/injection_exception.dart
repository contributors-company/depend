/// {@template injection_exception}
/// An exception used for handling errors related to dependency injection
/// in the application.
///
/// This class implements the [Exception] interface and allows an additional
/// message to be passed that describes the cause of the error when creating
/// an instance of the exception.
///
/// It also stores the [stackTrace], which provides additional context
/// about where the exception occurred.
///
/// Example:
/// ```dart
/// try {
///   throw InjectionException('Error initializing dependency');
/// } catch (e, stack) {
///   throw InjectionException('Error initializing dependency', stackTrace: stack);
/// }
/// ```
/// {@endtemplate}
class InjectionException implements Exception {
  /// {@macro injection_exception}
  ///
  /// Constructor that takes a [message] — a string message about the error,
  /// and an optional [stackTrace], which provides details of where the error occurred.
  InjectionException(this.message, {this.stackTrace});

  /// {@template message}
  /// The error [message] related to dependency injection.
  ///
  /// This message is available when handling the exception and can be used
  /// for logging or displaying to the user.
  /// {@endtemplate}
  final String message;

  /// {@template stackTrace}
  /// The [stackTrace] that provides context about where the exception occurred.
  ///
  /// This is particularly useful for debugging and logging purposes.
  /// {@endtemplate}
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'InjectionException: $message${stackTrace != null ? '\n$stackTrace' : ''}';
}
