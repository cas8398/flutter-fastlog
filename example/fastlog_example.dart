import 'package:flutter_fastlog/flutter_fastlog.dart';

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
  FastLog.info(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam.");
}
