import 'return_log.dart';
import 'package:flutter/foundation.dart'; // Import this to use kDebugMode

/// Generates log structure before formatting
String generateLog(
  String message,
  String level,
  String tag,
  bool justDebug,
  bool showTime,
  bool useEmoji,
  bool isColored,
  String logLevel,
  List<String> levels,
  Map<String, String> emojis,
  String callerInfo,
) {
  if (justDebug && !_isDebugMode()) return "";
  if (levels.indexOf(level) < levels.indexOf(logLevel)) return "";

  final timestamp = showTime ? _formattedTime() : "";
  final emoji = useEmoji ? emojis[level] ?? "" : "";

  final formattedLog = returnLog(
    level,
    tag,
    callerInfo,
    isColored,
    emoji,
    timestamp,
    message,
  );

  // Use print instead of debugPrint to keep it Dart-compatible
  print(formattedLog);

  return formattedLog;
}

/// Helper method to check debug mode
bool _isDebugMode() {
  return kDebugMode; // This checks if the app is in debug mode
}

/// Format date
String _formattedTime() {
  final now = DateTime.now();

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  return "${now.year}/${twoDigits(now.month)}/${twoDigits(now.day)} - "
      "${twoDigits(now.hour)}:${twoDigits(now.minute)}:${twoDigits(now.second)}";
}
