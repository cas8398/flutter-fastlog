import 'package:fastlog/fastlog.dart';

void main() {
  // Configure logging once at startup
  FastLog.config(
    justDebug: false,
    isColored: true,
    showTime: false,
    messageLimit: 300,
    logLevel: "TRACE",
    customEmojis: {
      "WARN": "❗",
      "ERROR": "🔥",
    },
  );

  // Run code
  FastLog.info("This won't be shown either.");
}
