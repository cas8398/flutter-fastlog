import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:flutter_fastlog/flutter_fastlog.dart';

void main() {
  setUp(() {
    // Reset log configuration before each test
    FastLog.config(
      showLog: !kReleaseMode,
      isColored: true,
      useEmoji: true,
      prettyJson: true,
      showTime: true,
      showCaller: true,
      messageLimit: 300,
      logLevel: "TRACE",
      outputStyle: OutputStyle.standard,
      customEmojis: {
        "WARN": "❗",
        "ERROR": "🔥",
      },
    );
  });

  test("FastLog should log messages at correct levels", () {
    expect(
        () => FastLog.trace(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () => FastLog.debug(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () => FastLog.info(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () => FastLog.warn(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () => FastLog.error(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () => FastLog.fatal(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam condimentum tempor urna. Sed vel eros pretium, pulvinar turpis quis, vestibulum lectus. Mauris id vehicula elit. Integer vehicula, nisl sit amet volutpat bibendum, urna est euismod sapien, ac luctus justo urna vitae velit. Etiam varius lorem vel varius blandit. Phasellus nibh ex, pharetra ac neque id, eleifend facilisis mi. Nulla tincidunt quis eros vitae semper. Phasellus ipsum ipsum, ultricies vel augue at, varius efficitur ante. In commodo ex non neque commodo, quis viverra arcu aliquam."),
        returnsNormally);
    expect(
        () =>
            FastLog.debug("This is Debug  log with Custom tag : DB", tag: "DB"),
        returnsNormally);

    // Test shorthand methods
    expect(() => FastLog.t("This is a trace message with shorthand"),
        returnsNormally);
    expect(() => FastLog.d("This is a debug message with shorthand"),
        returnsNormally);
    expect(() => FastLog.i("This is an info message with shorthand"),
        returnsNormally);
    expect(() => FastLog.w("This is a warning message with shorthand"),
        returnsNormally);
    expect(() => FastLog.e("This is an error message with shorthand"),
        returnsNormally);
    expect(() => FastLog.f("This is a fatal message with shorthand"),
        returnsNormally);

    // Test shorthand methods with tags
    expect(() => FastLog.d("Debug with tag shorthand", tag: "SHORT"),
        returnsNormally);
    expect(() => FastLog.e("Error with tag shorthand", tag: "ERR"),
        returnsNormally);

    final sampleJson = {
      "user": {
        "id": 123,
        "name": "John Doe",
        "email": "johndoe@example.com",
        "active": true
      },
      "posts": [
        {
          "id": 1,
          "title": "My first post",
          "content": "This is the content of my first post."
        },
        {
          "id": 2,
          "title": "Another post",
          "content": "This is some more content."
        }
      ]
    };
    expect(() => FastLog.info(sampleJson), returnsNormally);
    expect(() => FastLog.i(sampleJson), returnsNormally); // Shorthand version
  });

  test("FastLog should not log lower levels than config", () {
    FastLog.config(logLevel: "WARN"); // INFO & DEBUG should not be logged

    expect(
        () => FastLog.info(
            "This should NOT be logged This should NOT be logged "),
        returnsNormally);
    expect(() => FastLog.i("This should NOT be logged with shorthand either"),
        returnsNormally);
  });

  test("FastLog shorthand methods should respect log level configuration", () {
    FastLog.config(logLevel: "ERROR"); // Only ERROR and FATAL should be logged

    // These should NOT be logged (below ERROR level)
    expect(() => FastLog.t("Trace shorthand"), returnsNormally);
    expect(() => FastLog.d("Debug shorthand"), returnsNormally);
    expect(() => FastLog.i("Info shorthand"), returnsNormally);
    expect(() => FastLog.w("Warn shorthand"), returnsNormally);

    // These SHOULD be logged (ERROR level and above)
    expect(() => FastLog.e("Error shorthand"), returnsNormally);
    expect(() => FastLog.f("Fatal shorthand"), returnsNormally);
  });

  test("FastLog should handle mixed full and shorthand methods", () {
    // Test that both full and shorthand methods work together
    expect(() {
      FastLog.trace("Full method");
      FastLog.t("Shorthand method");
      FastLog.debug("Full method");
      FastLog.d("Shorthand method");
      FastLog.info("Full method");
      FastLog.i("Shorthand method");
      FastLog.warn("Full method");
      FastLog.w("Shorthand method");
      FastLog.error("Full method");
      FastLog.e("Shorthand method");
      FastLog.fatal("Full method");
      FastLog.f("Shorthand method");
    }, returnsNormally);
  });

  test("FastLog should apply same configuration to shorthand methods", () {
    FastLog.config(
      messageLimit: 50,
      showTime: false,
      customEmojis: {"INFO": "📝"},
    );

    // Both full and shorthand should use the same configuration
    expect(
        () => FastLog.info(
            "This is a long message that should be truncated due to message limit configuration"),
        returnsNormally);
    expect(
        () => FastLog.i(
            "This is another long message that should be truncated due to message limit configuration"),
        returnsNormally);
  });
}
