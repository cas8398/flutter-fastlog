import 'dart:async';
import 'dart:convert';
import 'generate_log.dart';

/// A super lightweight and high-performance logging package for Dart and Flutter.
class FastLog {
  static bool _justDebug = true;
  static bool _isColored = true;
  static bool _showTime = false;
  static bool _useEmoji = true;
  static String _logLevel = "TRACE";
  static int _messageLimit = 200; // Default character limit

  static final StreamController<String> _logController =
      StreamController.broadcast();

  /// Log levels in priority order.
  static const List<String> _levels = [
    "TRACE",
    "DEBUG",
    "INFO",
    "WARN",
    "ERROR",
    "FATAL"
  ];

  static final Map<String, String> _emojis = {
    "TRACE": "🕵️",
    "DEBUG": "🔧",
    "INFO": "📢",
    "WARN": "⚠️",
    "ERROR": "🚨",
    "FATAL": "☠️",
  };

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

  static void setLogLevel(String level) {
    final upperLevel = level.toUpperCase();
    if (_levels.contains(upperLevel)) {
      _logLevel = upperLevel;
    }
  }

  static String _convertMessage(dynamic message) {
    try {
      if (message is String) return message;
      return jsonEncode(message);
    } catch (e) {
      return "[Non-Serializable] ${message.runtimeType}: ${message.toString()}";
    }
  }

  static String _limitMessage(dynamic message) {
    final String convertedMessage = _convertMessage(message);
    return convertedMessage.length > _messageLimit
        ? "${convertedMessage.substring(0, _messageLimit)}..."
        : convertedMessage;
  }

  static String _limitTag(String tag, int limitValue) {
    final String convertedMessage = _convertMessage(tag);
    return convertedMessage.length > limitValue
        ? "${convertedMessage.substring(0, limitValue)}.."
        : convertedMessage;
  }

  static Future<void> trace(dynamic message, {String tag = ""}) async =>
      await _log("TRACE", message, tag);
  static Future<void> debug(dynamic message, {String tag = ""}) async =>
      await _log("DEBUG", message, tag);
  static Future<void> info(dynamic message, {String tag = ""}) async =>
      await _log("INFO", message, tag);
  static Future<void> warn(dynamic message, {String tag = ""}) async =>
      await _log("WARN", message, tag);
  static Future<void> error(dynamic message, {String tag = ""}) async =>
      await _log("ERROR", message, tag);
  static Future<void> fatal(dynamic message, {String tag = ""}) async =>
      await _log("FATAL", message, tag);

  static Future<void> _log(String level, dynamic message, String tag) async {
    final logMessage = generateLog(
      _limitMessage(message),
      level,
      _limitTag(tag, 7),
      _justDebug,
      _showTime,
      _useEmoji,
      _isColored,
      _logLevel,
      _levels,
      _emojis,
    );

    _logController.add(logMessage);
    await Future.delayed(Duration.zero, () => print(logMessage));
  }

  static Stream<String> get logStream => _logController.stream;
}
