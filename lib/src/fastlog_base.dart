import 'dart:convert';

class OutputStyle {
  static const standard = 0;
  static const minimal = 1;
  static const none = 2;
  static const colored = 3;
}

// Pre-defined color codes - compile-time constants
const _colors = {
  "TRACE": "\x1B[90m",
  "DEBUG": "\x1B[34m",
  "INFO": "\x1B[32m",
  "WARN": "\x1B[33m",
  "ERROR": "\x1B[31m",
  "FATAL": "\x1B[35m",
  "RESET": "\x1B[0m",
};

const _boxColors = {
  "TRACE": "\x1B[46m\x1B[30m",
  "DEBUG": "\x1B[44m\x1B[30m",
  "INFO": "\x1B[42m\x1B[30m",
  "WARN": "\x1B[43m\x1B[30m",
  "ERROR": "\x1B[41m\x1B[30m",
  "FATAL": "\x1B[45m\x1B[30m",
  "RESET": "\x1B[0m",
};

const _msgColors = {
  "TRACE": "\x1B[36m",
  "DEBUG": "\x1B[34m",
  "WARN": "\x1B[33m",
  "ERROR": "\x1B[31m",
  "FATAL": "\x1B[35m",
};

// Pre-computed separators
const _separator80 =
    "────────────────────────────────────────────────────────────────────────";

class FastLog {
  // Configuration with defaults
  static bool _showLog = true;
  static bool _isColored = true;
  static bool _showTime = true;
  static bool _useEmoji = true;
  static bool _showCaller = true;
  static bool _prettyJson = false;
  static int _messageLimit = 200;
  static String _logLevel = "DEBUG"; // Default level
  static int _outputStyle = OutputStyle.standard;

  // Fast level checking - using arrays instead of maps
  // Levels in order of increasing severity
  static const List<String> _levels = [
    "TRACE", // 0 - Most verbose
    "DEBUG", // 1
    "INFO", // 2
    "WARN", // 3
    "ERROR", // 4
    "FATAL" // 5 - Most severe
  ];
  static int _currentLevelIndex = 1; // DEBUG by default

  // Pre-computed data
  static final List<String> _emojis = ["🕵️ ", "🔧", "📢", "⚠️", "🚨", "☠️ "];

  // Caching
  static String? _cachedCallerInfo;
  static String? _cachedTime;
  static int _lastTimeSecond = -1;
  static String? _cachedTimeWithMs;
  static int _lastTimeMs = -1;

  // Cache padded levels to avoid repeated padding
  static final _paddedLevelCache = <String, String>{};

  /// Configures FastLog with custom settings
  ///
  /// Example:
  /// ```dart
  /// FastLog.config(
  ///   showLog: !kReleaseMode, // Auto-disable in production
  ///   isColored: true,
  ///   showTime: true,
  ///   useEmoji: true,
  ///   showCaller: true,
  ///   prettyJson: true,
  ///   logLevel: "DEBUG",
  ///   messageLimit: 300,
  ///   outputStyle: OutputStyle.standard,
  /// );
  /// ```
  static void config({
    bool? showLog,
    bool? isColored,
    bool? showTime,
    bool? useEmoji,
    bool? showCaller,
    bool? prettyJson,
    String? logLevel,
    int? messageLimit,
    Map<String, String>? customEmojis,
    int? outputStyle,
  }) {
    _showLog = showLog ?? _showLog;
    _isColored = isColored ?? _isColored;
    _showTime = showTime ?? _showTime;
    _useEmoji = useEmoji ?? _useEmoji;
    _showCaller = showCaller ?? _showCaller;
    _prettyJson = prettyJson ?? _prettyJson;
    _messageLimit = messageLimit ?? _messageLimit;
    _outputStyle = outputStyle ?? _outputStyle;

    if (logLevel != null) _setLogLevelInternal(logLevel);
    if (customEmojis != null) {
      for (final entry in customEmojis.entries) {
        final index = _levels.indexOf(entry.key);
        if (index != -1) _emojis[index] = entry.value;
      }
    }

    _clearCallerCache();
  }

  static void _setLogLevelInternal(String level) {
    final upperLevel = level.toUpperCase();
    final index = _levels.indexOf(upperLevel);
    if (index != -1) {
      _logLevel = upperLevel;
      _currentLevelIndex = index;
      print("FastLog: Log level set to $upperLevel (index: $index)");
    } else {
      print("FastLog: Invalid log level '$level'. Using $_logLevel");
    }
  }

  // CORRECTED: Ultra-fast level check
  // Should log if message level >= current level (more severe or equal)
  static bool _shouldLog(String level) {
    final levelIndex = _getLevelIndex(level);
    // CORRECTED: Use >= to include levels of equal or higher severity
    return levelIndex >= _currentLevelIndex;
  }

  static int _getLevelIndex(String level) {
    return switch (level) {
      "TRACE" => 0,
      "DEBUG" => 1,
      "INFO" => 2,
      "WARN" => 3,
      "ERROR" => 4,
      "FATAL" => 5,
      _ => -1,
    };
  }

  // Optimized message formatting
  static String _formatMessage(dynamic message) {
    if (message is String) return message;
    if (message is num) return message.toString();
    if (message is bool) return message ? 'true' : 'false';
    if (message == null) return 'null';

    try {
      if (_prettyJson && _shouldPrettyPrint(message)) {
        return const JsonEncoder.withIndent('  ').convert(message);
      }
      return jsonEncode(message);
    } catch (_) {
      return '{${message.runtimeType}}';
    }
  }

  static bool _shouldPrettyPrint(dynamic message) {
    return (message is Map || message is List) &&
        jsonEncode(message).length <= 1000;
  }

  // Stack trace parsing
  static String _getCallerInfo() {
    if (!_showCaller) return "";
    if (_cachedCallerInfo != null) return _cachedCallerInfo!;

    try {
      final stack = StackTrace.current;
      final lines = stack.toString().split('\n');

      // Start from line 3 to skip FastLog internal calls
      for (int i = 3; i < lines.length && i < 8; i++) {
        final line = lines[i];
        final match = RegExp(r'(\S+\.dart):(\d+):(\d+)').firstMatch(line);
        if (match != null && !line.contains('FastLog')) {
          final file = match.group(1)!.split('/').last;
          final lineNumber = match.group(2)!;
          _cachedCallerInfo = "$file:$lineNumber";
          return _cachedCallerInfo!;
        }
      }
    } catch (_) {
      // Silent fail
    }

    return "unknown";
  }

  static void _clearCallerCache() {
    _cachedCallerInfo = null;
  }

  // Optimized time formatting with caching
  static String _getCachedTime() {
    final now = DateTime.now();
    final currentSecond = now.second;

    if (_lastTimeSecond != currentSecond) {
      _lastTimeSecond = currentSecond;
      final h = now.hour.toString().padLeft(2, '0');
      final m = now.minute.toString().padLeft(2, '0');
      final s = now.second.toString().padLeft(2, '0');
      _cachedTime = "$h:$m:$s";
    }

    return _cachedTime!;
  }

  static String _getCachedTimeWithMs() {
    final now = DateTime.now();
    final currentMs = now.millisecondsSinceEpoch ~/ 10;

    if (_lastTimeMs != currentMs) {
      _lastTimeMs = currentMs;
      final h = now.hour.toString().padLeft(2, '0');
      final m = now.minute.toString().padLeft(2, '0');
      final s = now.second.toString().padLeft(2, '0');
      final ms = now.millisecond.toString().padLeft(3, '0');
      _cachedTimeWithMs = '$h:$m:$s.$ms';
    }

    return _cachedTimeWithMs!;
  }

  // Main logging methods
  static void trace(dynamic message, {String tag = ""}) =>
      _logInternal("TRACE", message, tag);
  static void debug(dynamic message, {String tag = ""}) =>
      _logInternal("DEBUG", message, tag);
  static void info(dynamic message, {String tag = ""}) =>
      _logInternal("INFO", message, tag);
  static void warn(dynamic message, {String tag = ""}) =>
      _logInternal("WARN", message, tag);
  static void error(dynamic message,
          {String tag = "", Object? error, StackTrace? stackTrace}) =>
      _logErrorInternal("ERROR", message, tag, error, stackTrace);
  static void fatal(dynamic message,
          {String tag = "", Object? error, StackTrace? stackTrace}) =>
      _logErrorInternal("FATAL", message, tag, error, stackTrace);

  // Shorthand methods
  static void t(dynamic message, {String tag = ""}) =>
      _logInternal("TRACE", message, tag);
  static void d(dynamic message, {String tag = ""}) =>
      _logInternal("DEBUG", message, tag);
  static void i(dynamic message, {String tag = ""}) =>
      _logInternal("INFO", message, tag);
  static void w(dynamic message, {String tag = ""}) =>
      _logInternal("WARN", message, tag);
  static void e(dynamic message,
          {String tag = "", Object? error, StackTrace? stackTrace}) =>
      _logErrorInternal("ERROR", message, tag, error, stackTrace);
  static void f(dynamic message,
          {String tag = "", Object? error, StackTrace? stackTrace}) =>
      _logErrorInternal("FATAL", message, tag, error, stackTrace);

  // String-only methods
  static void traceFast(String message) => _logUltraFast("TRACE", message);
  static void debugFast(String message) => _logUltraFast("DEBUG", message);
  static void infoFast(String message) => _logUltraFast("INFO", message);
  static void warnFast(String message) => _logUltraFast("WARN", message);
  static void errorFast(String message) => _logUltraFast("ERROR", message);

  // Core logging implementation
  static void _logInternal(String level, dynamic message, String tag) {
    if (!_showLog) return;

    // path for none output
    if (_outputStyle == OutputStyle.none) {
      final output = message is String ? message : _formatMessage(message);
      print('$level $output');
      return;
    }

    // Level filtering
    if (!_shouldLog(level)) return;

    final formattedMessage = message is String
        ? _limitStringIfNeeded(message)
        : _formatMessage(message);

    _emitLog(level, formattedMessage, tag);
  }

  static void _logErrorInternal(String level, dynamic message, String tag,
      Object? error, StackTrace? stackTrace) {
    if (!_showLog || !_shouldLog(level)) return;

    final errorMessage = _buildErrorMessage(message, error, stackTrace);
    _emitLog(level, _limitStringIfNeeded(errorMessage), tag);
  }

  static String _buildErrorMessage(
      dynamic message, Object? error, StackTrace? stackTrace) {
    if (error == null && stackTrace == null) {
      return message is String ? message : _formatMessage(message);
    }

    final buffer = StringBuffer();
    buffer.write(message is String ? message : _formatMessage(message));

    if (error != null) {
      buffer.write('\nError: $error');
    }

    if (stackTrace != null) {
      buffer.write('\nStack Trace:\n$stackTrace');
    }

    return buffer.toString();
  }

  // Logging (bypasses most formatting)
  static void _logUltraFast(String level, String message) {
    if (!_showLog || !_shouldLog(level)) return;

    if (_outputStyle == OutputStyle.none) {
      print('$level $message');
      return;
    }

    _emitLog(level, _limitStringIfNeeded(message), "");
  }

  static String _limitStringIfNeeded(String message) {
    return message.length > _messageLimit
        ? '${message.substring(0, _messageLimit)}...'
        : message;
  }

  // Optimized log emission
  static void _emitLog(String level, String message, String tag) {
    final output = _formatOutput(level, message, tag);
    if (output.isNotEmpty) {
      print(output);
    }
  }

  static String _formatOutput(String level, String message, String tag) {
    switch (_outputStyle) {
      case OutputStyle.none:
        return '$level $message';
      case OutputStyle.minimal:
        return _buildMinimalFormat(level, tag, message);
      case OutputStyle.standard:
        return _buildBoxFormat(level, tag, message);
      case OutputStyle.colored:
        return _buildColoredFormat(level, tag, message);
      default:
        return _buildBoxFormat(level, tag, message);
    }
  }

  //  Minimal format with proper parameter order
  static String _buildMinimalFormat(String level, String tag, String message) {
    final timePart = _showTime ? '[${_getCachedTimeWithMs()}] ' : '';
    final emojiPart = _useEmoji ? ' ${_emojis[_getLevelIndex(level)]} ' : '';
    final levelPart = _isColored ? '${_colors[level]}$level ' : '$level ';
    final tagPart = tag.isNotEmpty ? '$tag ' : '';
    final callerPart = _showCaller ? _getCallerInfo() : '';
    final resetPart = _isColored ? _colors["RESET"]! : '';

    return '$timePart$callerPart$emojiPart$levelPart$tagPart• $message$resetPart';
  }

  static String _buildColoredFormat(String level, String tag, String message) {
    final levelColor = _isColored ? _colors[level]! : "";
    final resetColor = _isColored ? _colors["RESET"]! : "";
    final valueMessage =
        _prettyJson ? _tryDecodeAndFormatJsonFast(message) : message;
    final messageColor = _isColored ? (_msgColors[level] ?? levelColor) : "";
    final emoji = _useEmoji ? _emojis[_getLevelIndex(level)] : "";

    final time = _showTime
        ? '${_colors["DEBUG"]!}[${_getCachedTimeWithMs()}]$resetColor '
        : '';
    final levelText = _isColored
        ? '$levelColor${level.toUpperCase()}$resetColor '
        : '${level.toUpperCase()} ';
    final emojiText = _useEmoji ? '$emoji ' : '';
    final tagText = tag.isNotEmpty ? '${_colors[level]!}$tag$resetColor ' : '';

    final caller = _showCaller ? '• ${_getCallerInfo()} ' : '';
    var separator = tag.isNotEmpty ? ' ' : '';

    if (_prettyJson && _isFormattedJson(valueMessage)) {
      final lines = valueMessage.split('\n');
      final header = '$time$emojiText$levelText$tagText$caller$separator';
      if (lines.length == 1) {
        return '$header$messageColor${lines.first}$resetColor';
      }
      return '$header$messageColor${lines.first}$resetColor\n${lines.skip(1).where((l) => l.isNotEmpty).map((l) => '    $messageColor$l$resetColor').join('\n')}';
    }

    return '$time$emojiText$levelText$tagText$caller$separator$messageColor$valueMessage$resetColor';
  }

  // Integrated box format
  static String _buildBoxFormat(String level, String tag, String message) {
    const separator = _separator80;
    final colors = _getBoxColors(level, _isColored);
    final header = _buildOptimizedHeader(level, tag, colors[0], colors[1]);
    final valueMessage =
        _prettyJson ? _tryDecodeAndFormatJsonFast(message) : message;

    // Build all lines in one list
    final lines = <String>[
      "  ┌$separator",
      "  │ $header",
      "  ├$separator",
    ];

    // Add message content
    if (_prettyJson && _isFormattedJson(valueMessage)) {
      lines.addAll(valueMessage
          .split('\n')
          .where((line) => line.isNotEmpty)
          .map((line) => "    ${colors[2]}$line${colors[3]}")
          .toList());
    } else {
      lines.addAll(_wrapTextUltraFast(valueMessage, 76)
          .map((line) => "  │ ${colors[2]}$line${colors[3]}")
          .toList());
    }

    lines.add("  └$separator");
    return lines.join('\n');
  }

  // Color getter
  static List<String> _getBoxColors(String level, bool isColored) {
    if (!isColored) return ["", "", "", ""];
    return [
      _boxColors[level] ?? "",
      _boxColors["RESET"] ?? "",
      level != "INFO" ? (_msgColors[level] ?? "") : "",
      level != "INFO" ? (_boxColors["RESET"] ?? "") : ""
    ];
  }

  // Header builder
  static String _buildOptimizedHeader(
      String level, String tag, String levelColor, String resetColor) {
    final formattedTag = tag.isNotEmpty ? tag : level;
    final paddedLevel = _getPaddedLevel(formattedTag);
    final emoji = _useEmoji ? _emojis[_getLevelIndex(level)] : "";
    final time = _showTime ? _getCachedTime() : null;
    final callerInfo = _showCaller ? _getCallerInfo() : "";

    final buffer = StringBuffer();
    buffer.write('$emoji  $levelColor');

    if (time != null) {
      buffer.write(' $time ');
    }

    buffer.write(' $paddedLevel$resetColor');

    final baseLength =
        emoji.length + 2 + (time != null ? time.length + 3 : 0) + 7 + 1;
    final spacesNeeded = 68 - baseLength - callerInfo.length;

    if (spacesNeeded > 0) {
      buffer.write(' ' * spacesNeeded);
    }

    if (_showCaller) {
      buffer.write('[$callerInfo]');
    }
    return buffer.toString();
  }

  static String _getPaddedLevel(String level) {
    return _paddedLevelCache[level] ??= level.padRight(6);
  }

  // JSON detection
  static bool _isFormattedJson(String text) {
    return text.contains('\n') && text.contains('  ');
  }

  // JSON formatting
  static String _tryDecodeAndFormatJsonFast(String message) {
    if (!_looksLikeJsonFast(message)) return message;
    try {
      final decoded = jsonDecode(message);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return message;
    }
  }

  static bool _looksLikeJsonFast(String message) {
    if (message.length < 4) return false;
    final firstChar = message.codeUnitAt(0);
    final lastChar = message.codeUnitAt(message.length - 1);
    final hasJsonBraces = (firstChar == 123 && lastChar == 125) ||
        (firstChar == 91 && lastChar == 93);
    return hasJsonBraces && message.contains(':');
  }

  // Text wrapping
  static List<String> _wrapTextUltraFast(String text, int maxWidth) {
    if (text.length <= maxWidth) return [text];
    final lines = <String>[];
    for (int i = 0; i < text.length; i += maxWidth) {
      final end = i + maxWidth;
      lines.add(text.substring(i, end < text.length ? end : text.length));
    }
    return lines;
  }

  // Utility methods
  static void setLogLevel(String level) => _setLogLevelInternal(level);
  static void setOutputStyle(int style) => _outputStyle = style;
  static void setPrettyJson(bool enabled) => _prettyJson = enabled;
  static void clearCache() => _clearCallerCache();

  // Getters for debugging
  static String get currentLogLevel => _logLevel;
  static int get currentLevelIndex => _currentLevelIndex;
  static List<String> get availableLevels => _levels;
}
