import 'dart:convert';
import 'generate_log.dart';

/// A super lightweight and high-performance logging package for Dart and Flutter.
class FastLog {
  static bool _justDebug = true;
  static bool _isColored = true;
  static bool _showTime = false;
  static bool _useEmoji = true;
  static String _logLevel = "INFO";
  static int _messageLimit = 200; // Default character limit

  /// Log levels in priority order.
  ///
  /// The log levels are ordered by priority: TRACE < DEBUG < INFO < WARN < ERROR < FATAL.
  static const List<String> _levels = [
    "TRACE",
    "DEBUG",
    "INFO",
    "WARN",
    "ERROR",
    "FATAL"
  ];

  /// Default emoji indicators for each log level.
  ///
  /// These emojis are used for visual indication of log levels when `useEmoji` is enabled.
  static final Map<String, String> _emojis = {
    "TRACE": "🕵️", // Spyglass for tracing
    "DEBUG": "🔧", // Wrench for debugging
    "INFO": "📢", // Loudspeaker for general information
    "WARN": "⚠️", // Warning sign for warnings
    "ERROR": "🚨", // Alarm for errors
    "FATAL": "☠️", // Skull for fatal errors
  };

  /// Configure global logging settings.
  ///
  /// - `justDebug`: If true, only debug logs are shown. Default is true.
  /// - `isColored`: If true, log output will be colorized. Default is true.
  /// - `showTime`: If true, log timestamps will be displayed. Default is false.
  /// - `useEmoji`: If true, emojis will be included in log output. Default is true.
  /// - `logLevel`: The default log level to use. Logs below this level will be ignored.
  /// - `messageLimit`: The maximum number of characters for log messages.
  /// - `customEmojis`: A map of custom emojis to override the default ones for each log level.
  static void config({
    bool? justDebug,
    bool? isColored,
    bool? showTime,
    bool? useEmoji,
    String? logLevel,
    int? messageLimit,
    Map<String, String>? customEmojis,
  }) {
    _justDebug = justDebug ?? _justDebug;
    _isColored = isColored ?? _isColored;
    _showTime = showTime ?? _showTime;
    _useEmoji = useEmoji ?? _useEmoji;
    _messageLimit = (messageLimit != null && messageLimit > 0)
        ? messageLimit
        : _messageLimit;
    if (logLevel != null) setLogLevel(logLevel);
    if (customEmojis != null) _emojis.addAll(customEmojis);
  }

  /// Validate and set the log level.
  ///
  /// This method ensures that the provided log level is valid and exists in the `_levels` list.
  /// If the level is valid, it is set as the active log level.
  ///
  /// - `level`: The log level to set (e.g., "INFO", "DEBUG").
  static void setLogLevel(String level) {
    final upperLevel = level.toUpperCase();
    if (_levels.contains(upperLevel)) {
      _logLevel = upperLevel;
    }
  }

  /// Safely convert message to a string.
  ///
  /// This method ensures that any message is properly converted into a string representation.
  /// If the message is a non-serializable object, it will be converted into a readable format.
  ///
  /// - `message`: The message to convert.
  ///
  /// Returns a string representation of the message.
  static String _convertMessage(dynamic message) {
    try {
      if (message is String) return message;
      return jsonEncode(message);
    } catch (e) {
      return "[Non-Serializable] ${message.runtimeType}: ${message.toString()}";
    }
  }

  /// Helper function to apply message limit.
  ///
  /// This method ensures that the log message does not exceed the predefined character limit.
  /// If the message exceeds the limit, it will be truncated and an ellipsis will be appended.
  ///
  /// - `message`: The message to apply the limit to.
  ///
  /// Returns the formatted message.
  static String _limitMessage(dynamic message) {
    final String convertedMessage = _convertMessage(message);
    return convertedMessage.length > _messageLimit
        ? "${convertedMessage.substring(0, _messageLimit)}..."
        : convertedMessage;
  }

  /// Generate log messages for the TRACE log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the TRACE level.
  static String trace(dynamic message) => _log("TRACE", message);

  /// Generate log messages for the DEBUG log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the DEBUG level.
  static String debug(dynamic message) => _log("DEBUG", message);

  /// Generate log messages for the INFO log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the INFO level.
  static String info(dynamic message) => _log("INFO", message);

  /// Generate log messages for the WARN log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the WARN level.
  static String warn(dynamic message) => _log("WARN", message);

  /// Generate log messages for the ERROR log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the ERROR level.
  static String error(dynamic message) => _log("ERROR", message);

  /// Generate log messages for the FATAL log level.
  ///
  /// - `message`: The message to log.
  ///
  /// Returns the generated log message for the FATAL level.
  static String fatal(dynamic message) => _log("FATAL", message);

  /// Internal log function to generate log messages for a given level.
  ///
  /// This function assembles the log message based on the provided level and message.
  /// It incorporates the global settings like color, emoji, timestamp, and log level.
  ///
  /// - `level`: The log level to generate (e.g., "INFO", "DEBUG").
  /// - `message`: The message to log.
  ///
  /// Returns the formatted log message.
  static String _log(String level, dynamic message) {
    return generateLog(
      _limitMessage(message),
      level,
      _justDebug,
      _showTime,
      _useEmoji,
      _isColored,
      _logLevel,
      _levels,
      _emojis,
    );
  }
}
