import 'dart:convert';
import 'generate_log.dart';

class FastLog {
  static bool _justDebug = true;
  static bool _isColored = true;
  static bool _showTime = false;
  static bool _useEmoji = true;
  static String _logLevel = "INFO";
  static int _messageLimit = 200; // Default character limit

  /// Log levels in priority order
  static const List<String> _levels = [
    "TRACE",
    "DEBUG",
    "INFO",
    "WARN",
    "ERROR",
    "FATAL"
  ];

  /// Default emoji indicators
  static final Map<String, String> _emojis = {
    "TRACE": "🕵️", // Spyglass for tracing
    "DEBUG": "🔧", // Wrench for debugging
    "INFO": "📢", // Loudspeaker for general information
    "WARN": "⚠️", // Warning sign for warnings
    "ERROR": "🚨", // Alarm for errors
    "FATAL": "☠️", // Skull for fatal errors
  };

  /// Configure global logging settings
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

  /// Validate and set the log level
  static void setLogLevel(String level) {
    final upperLevel = level.toUpperCase();
    if (_levels.contains(upperLevel)) {
      _logLevel = upperLevel;
    }
  }

  /// Safely convert message to a string
  static String _convertMessage(dynamic message) {
    try {
      if (message is String) return message;
      return jsonEncode(message);
    } catch (e) {
      return "[Non-Serializable] ${message.runtimeType}: ${message.toString()}";
    }
  }

  /// Helper function to apply message limit
  static String _limitMessage(dynamic message) {
    final String convertedMessage = _convertMessage(message);
    return convertedMessage.length > _messageLimit
        ? "${convertedMessage.substring(0, _messageLimit)}..."
        : convertedMessage;
  }

  /// Generate log messages for different levels
  static String trace(dynamic message) => _log("TRACE", message);
  static String debug(dynamic message) => _log("DEBUG", message);
  static String info(dynamic message) => _log("INFO", message);
  static String warn(dynamic message) => _log("WARN", message);
  static String error(dynamic message) => _log("ERROR", message);
  static String fatal(dynamic message) => _log("FATAL", message);

  /// Internal log function
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
