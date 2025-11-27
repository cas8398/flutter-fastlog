import 'package:flutter/foundation.dart';
import 'package:flutter_fastlog/flutter_fastlog.dart';

void main() {
  // Configure logging once at startup
  FastLog.config(
    showLog:
        !kReleaseMode, // Show debug logs only in dev mode, auto-disable in production
    isColored: true, // Enable ANSI color codes for better log readability
    useEmoji: true, // Use emojis as visual indicators for different log levels
    outputStyle:
        OutputStyle.standard, // Choose from: standard, minimal, none, colored
    prettyJson: true, // Automatically format JSON objects with indentation
    messageLimit: 300, // Truncate long messages to prevent console overflow
    showTime: true, // Display timestamp for each log entry
    showCaller: true, // Show file and line number where log was called

    // Log level filtering (in order of severity)
    logLevel: "TRACE", // Options: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    // TRACE = most verbose (shows everything)
    // DEBUG = development debugging
    // INFO = general information
    // WARN = warnings
    // ERROR = errors
    // FATAL = critical errors only
  );

  // Run code
  FastLog.info(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam.");
}
