import 'package:fastlog/fastlog.dart';

void main() {
  // Configure logging once at startup
  FastLog.config(
      justDebug: true, isColored: true, showTime: false, logLevel: "WARN");

  // Run code
  FastLog.info("This won't be shown either.");
}
