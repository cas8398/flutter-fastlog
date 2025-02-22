import 'package:test/test.dart';
import 'package:flutter_fastlog/flutter_fastlog.dart';

void main() {
  setUp(() {
    // Reset log configuration before each test
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
  });

  test("FastLog should log messages at correct levels", () {
    expect(() => FastLog.trace("TRACE log"), returnsNormally);
    expect(() => FastLog.debug("DEBUG log"), returnsNormally);
    expect(() => FastLog.info("INFO log"), returnsNormally);
    expect(() => FastLog.warn("WARN log"), returnsNormally);
    expect(() => FastLog.error("ERROR log"), returnsNormally);
    expect(() => FastLog.fatal("FATAL log"), returnsNormally);
    expect(
        () => FastLog.info(
            "FastLog should not log lower levels than config FastLog should not log lower levels than config FastLog should not log lower levels than config FastLog should not log lower levels than config"),
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
    expect(() => FastLog.debug("This should NOT be logged"), returnsNormally);
  });
}
