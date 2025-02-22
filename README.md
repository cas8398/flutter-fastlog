# Flutter FastLog

A super lightweight and high-performance logging package for Dart and Flutter.  
Supports customizable log levels, colors, timestamps, tag, and emojis.

## Features

- **Lightweight**: Optimized for minimal resource usage.
- **High Performance**: Designed to log messages efficiently.
- **Configurable**: Customizable log levels, colors, and emojis.
- **Easy to Use**: Simple API for logging different levels of messages.

## Installation

To use `flutter_fastlog` in your Dart or Flutter project, add the following to your `pubspec.yaml` file:

```yaml
dependencies:
flutter_fastlog: ^0.1.4
```

Then run:

```bash
flutter pub get
```

## Usage

### Configuration

You can configure the logging behavior using the \`FastLog.config()\` method:

```dart
FastLog.config(
justDebug: true, // Only show debug logs
isColored: true, // Enable colored output
showTime: true, // Show timestamp in logs
useEmoji: true, // Use emojis in logs
logLevel: "TRACE", // Set the default log level
messageLimit: 200, // Limit log message length
);
```

### Log Levels

You can log messages at different levels:

```dart
FastLog.trace("This is a trace message");
FastLog.debug("This is a debug message");
FastLog.info("This is an info message");
FastLog.warn("This is a warning message");
FastLog.error("This is an error message");
FastLog.fatal("This is a fatal message");
FastLog.debug("This is Debug  log with Custom tag : DB", tag: "DB") // custom tag
```

### Output

![Output Fastlog](https://raw.githubusercontent.com/cas8398/flutter-fastlog/refs/heads/master/screenshot/fastlog-sample.png)

### Example

Here’s a simple example of logging with `flutter_fastlog`:

```dart
import 'package:flutter_fastlog/fastlog.dart';

void main() {
// Configure logging
FastLog.config(
justDebug: true,
isColored: true,
showTime: true,
useEmoji: true,
logLevel: "DEBUG",
messageLimit: 100,
);

// Log messages at different levels
FastLog.debug("This is a debug message");
FastLog.info("This is an info message");
FastLog.error("This is an error message");
FastLog.debug("This is Debug  log with Custom tag : DB", tag: "DB") // custom tag
}
```

## Contribution

Contributions are welcome! If you have suggestions or improvements, feel free to open an issue or pull request on the [GitHub repository](https://github.com/cas8398/flutter-fastlog).

## License

This package is open source and available under the [MIT License](https://github.com/cas8398/flutter-fastlog/blob/master/LICENSE).
