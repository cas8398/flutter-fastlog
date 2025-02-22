import 'dart:convert';
import 'dart:core';

String returnLog(
    String level, bool isColored, String emoji, String? time, String message) {
  // ANSI color codes for log levels
  final Map<String, String> colors = {
    "TRACE": "\x1B[46m\x1B[30m", // Cyan BG, Black text
    "DEBUG": "\x1B[44m\x1B[37m", // Blue BG, White text
    "INFO": "\x1B[42m\x1B[37m", // Green BG, White text (improved contrast)
    "WARN": "\x1B[43m\x1B[30m", // Yellow BG, Black text
    "ERROR": "\x1B[41m\x1B[37m", // Red BG, White text
    "FATAL": "\x1B[45m\x1B[30m", // Magenta BG, Black text (better readability)
    "RESET": "\x1B[0m",
  };

  // Message colors (except INFO)
  final Map<String, String> msgColors = {
    "TRACE": "\x1B[36m", // Cyan
    "DEBUG": "\x1B[34m", // Blue
    "WARN": "\x1B[33m", // Yellow
    "ERROR": "\x1B[31m", // Red
    "FATAL": "\x1B[35m", // Magenta
  };

  // Get caller information
  final callerInfo = _getCallerInfo();

  // Fixed column widths
  const int levelWidth = 6; // Fixed width for log levels
  final int timeWidth = time != null ? time.length + 2 : 0; // +2 for brackets
  const int tableWidth = 80; // Fixed total table width

  // Calculate dynamic spacing
  final String paddedLevel = level.padRight(levelWidth);
  final int usedWidth = levelWidth + timeWidth + 6; // Extra padding
  final int callerStartPos =
      tableWidth - callerInfo.length - 4; // Space for brackets

  // Format log header dynamically with right-aligned caller info
  final logHeader = "$emoji  ${isColored ? colors[level] ?? "" : ""}"
      "${time != null ? " $time " : ""}"
      " $paddedLevel${colors["RESET"]}"
      "${" " * (callerStartPos - usedWidth)}[$callerInfo]";

  // Apply color to message (except INFO)
  final msgColor = isColored && level != "INFO" ? (msgColors[level] ?? "") : "";

  // Check if message is valid JSON
  bool isValidJson = _isJson(message);
  String outputMessage = isValidJson ? _prettyJson(message) : message;

  // Max separator length
  const int maxSeparatorLength = tableWidth;
  final String separator = "─" * maxSeparatorLength;

  // Wrap long message properly
  final List<String> wrappedMessage =
      _wrapText("$msgColor$outputMessage${colors["RESET"]}", tableWidth - 4);

  return """
  ┌$separator
  │ $logHeader
  ├$separator
${wrappedMessage.map((line) => "  │ $line").join("\n")}
  └$separator
  """;
}

// Function to check if a string is valid JSON
bool _isJson(String str) {
  try {
    jsonDecode(str);
    return true;
  } catch (e) {
    return false;
  }
}

// Function to pretty-print JSON string with adjusted padding
String _prettyJson(String jsonString) {
  try {
    var decodedJson = jsonDecode(jsonString);
    // Using JsonEncoder.withIndent to pretty-print with indent of 2 spaces
    return JsonEncoder.withIndent("  ").convert(decodedJson);
  } catch (e) {
    return jsonString; // If not valid JSON, return original string
  }
}

// Function to wrap text properly, ensuring proper padding for JSON
List<String> _wrapText(String text, int maxWidth) {
  List<String> lines = [];
  while (text.length > maxWidth) {
    int lastSpace = text.substring(0, maxWidth).lastIndexOf(" ");
    if (lastSpace == -1) lastSpace = maxWidth; // Break at maxWidth if no spaces
    lines.add(text.substring(0, lastSpace));
    text = text.substring(lastSpace).trim();
  }
  lines.add(text); // Add remaining text
  return lines;
}

// Function to extract caller info
String _getCallerInfo() {
  try {
    final trace = StackTrace.current.toString().split("\n")[2]; // Get caller
    final match = RegExp(r'(\S+\.dart):(\d+):(\d+)').firstMatch(trace);
    if (match != null) {
      final file = match.group(1)?.split('/').last ?? "unknown";
      final line = match.group(2) ?? "0";
      return "$file:$line";
    }
  } catch (e) {
    return "unknown";
  }
  return "unknown";
}
