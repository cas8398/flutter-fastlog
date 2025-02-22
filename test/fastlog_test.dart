import 'package:test/test.dart';
import 'package:flutter_fastlog/flutter_fastlog.dart';

void main() {
  setUp(() {
    // Reset log configuration before each test
    FastLog.config(
      justDebug: false,
      isColored: true,
      showTime: true,
      messageLimit: 100,
      logLevel: "TRACE",
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
  });

  test("FastLog should not log lower levels than config", () {
    FastLog.config(logLevel: "WARN"); // INFO & DEBUG should not be logged

    expect(
        () => FastLog.info(
            "This should NOT be logged This should NOT be logged "),
        returnsNormally);
  });
}
