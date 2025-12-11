import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// [Service] Structured logging utility with file rotation and zero production impact.
/// Purpose: Provides debug logging with lazy evaluation, file persistence, and loop throttling.
///
/// All logging operations are wrapped in `kDebugMode` checks to ensure complete
/// code elimination in production builds (Constitution Principle I).
///
/// Usage:
/// ```dart
/// AppLogger.initialize(format: LogFormat.console);
/// AppLogger.debug('MyClass', 'myMethod', () => 'Processing item $index');
/// ```
class AppLogger {
  static LogFormat _format = LogFormat.console;
  static LogLevel _minLevel = LogLevel.debug; // Default: log everything
  static int _maxFileSize = 5 * 1024 * 1024; // 5MB default
  static int _maxFiles = 5;
  static File? _currentLogFile;
  static IOSink? _logSink;
  static final Map<String, DateTime> _lastLogTimes = {};
  static bool _isInitialized = false;

  /// Initializes the logger with specified format and file rotation settings.
  /// Must be called before any logging operations.
  ///
  /// Parameters:
  /// - [format]: Output format (console or json)
  /// - [minLevel]: Minimum log level to record (default: debug - logs everything)
  /// - [maxFileSize]: Maximum size in bytes before rotation (default: 5MB, json only)
  /// - [maxFiles]: Number of log files to keep (default: 5, json only)
  ///
  /// Note: Console format does NOT create log files. File parameters are ignored.
  ///
  /// Example:
  /// ```dart
  /// // Console-only logging with warning level minimum
  /// AppLogger.initialize(
  ///   format: LogFormat.console,
  ///   minLevel: LogLevel.warning,
  /// );
  ///
  /// // JSON logging with file rotation
  /// AppLogger.initialize(
  ///   format: LogFormat.json,
  ///   minLevel: LogLevel.debug,
  ///   maxFileSize: 5 * 1024 * 1024,
  ///   maxFiles: 5,
  /// );
  /// ```
  static Future<void> initialize({
    required LogFormat format,
    LogLevel minLevel = LogLevel.debug,
    int maxFileSize = 5 * 1024 * 1024,
    int maxFiles = 5,
  }) async {
    if (kDebugMode) {
      _format = format;
      _minLevel = minLevel;
      _maxFileSize = maxFileSize;
      _maxFiles = maxFiles;

      // Only initialize file logging for JSON format
      if (_format == LogFormat.json) {
        await _initializeLogFile();
      }

      _isInitialized = true;
    }
  }

  /// Logs a debug-level message with lazy evaluation.
  /// Only evaluated and logged in debug builds and if minLevel allows.
  ///
  /// Parameters:
  /// - [className]: Name of the class where log originates
  /// - [methodName]: Name of the method where log originates
  /// - [messageFn]: Lazy function that returns the message string
  ///
  /// Throws: Never throws - all errors are caught and logged to console
  static void debug(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode && _minLevel.index <= LogLevel.debug.index) {
      _log('DEBUG', className, methodName, messageFn);
    }
  }

  /// Logs an info-level message with lazy evaluation.
  /// Use for high-level events like user actions or state changes.
  /// Only logged if minLevel allows.
  ///
  /// Parameters:
  /// - [className]: Name of the class where log originates
  /// - [methodName]: Name of the method where log originates
  /// - [messageFn]: Lazy function that returns the message string
  static void info(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode && _minLevel.index <= LogLevel.info.index) {
      _log('INFO', className, methodName, messageFn);
    }
  }

  /// Logs a warning-level message with lazy evaluation.
  /// Use for recoverable issues or deprecated usage.
  /// Only logged if minLevel allows.
  ///
  /// Parameters:
  /// - [className]: Name of the class where log originates
  /// - [methodName]: Name of the method where log originates
  /// - [messageFn]: Lazy function that returns the message string
  static void warning(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode && _minLevel.index <= LogLevel.warning.index) {
      _log('WARNING', className, methodName, messageFn);
    }
  }

  /// Logs an error-level message with lazy evaluation.
  /// Use for failures that impact functionality.
  /// Only logged if minLevel allows.
  ///
  /// Parameters:
  /// - [className]: Name of the class where log originates
  /// - [methodName]: Name of the method where log originates
  /// - [messageFn]: Lazy function that returns the message string
  static void error(
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    if (kDebugMode && _minLevel.index <= LogLevel.error.index) {
      _log('ERROR', className, methodName, messageFn);
    }
  }

  // ============================================================
  // Private Helpers
  // ============================================================

  /// Core logging implementation with throttling and dual output.
  /// Prevents spam from loops by throttling repeated logs from same location.
  static void _log(
    String severity,
    String className,
    String methodName,
    String Function() messageFn,
  ) {
    try {
      final location = '$className.$methodName';
      final now = DateTime.now();

      // Throttle: only log if >1 second since last log from this location
      final lastTime = _lastLogTimes[location];
      if (lastTime != null && now.difference(lastTime).inSeconds < 1) {
        return; // Skip this log (throttled)
      }

      _lastLogTimes[location] = now;

      // Evaluate message (only happens in debug mode)
      final message = messageFn();

      // Write to console
      _writeToConsole(severity, className, methodName, message, now);

      // Write to file (only for JSON format)
      if (_format == LogFormat.json) {
        _writeToFile(severity, className, methodName, message, now);
      }
    } catch (e) {
      // Never crash app due to logging failure
      debugPrint('AppLogger error: $e');
    }
  }

  /// Writes log entry to console in human-readable format.
  /// Format: [timestamp] [LEVEL] className.methodName: message
  static void _writeToConsole(
    String severity,
    String className,
    String methodName,
    String message,
    DateTime timestamp,
  ) {
    if (_format == LogFormat.console) {
      final timeStr = _formatTimestamp(timestamp);
      debugPrint('[$timeStr] [$severity] $className.$methodName: $message');
    } else {
      // JSON format for console
      final json = _buildJsonLog(
        severity,
        className,
        methodName,
        message,
        timestamp,
        false,
      );
      debugPrint(jsonEncode(json));
    }
  }

  /// Writes log entry to file with rotation support.
  /// Handles file size limits and maintains maximum file count.
  static Future<void> _writeToFile(
    String severity,
    String className,
    String methodName,
    String message,
    DateTime timestamp,
  ) async {
    try {
      if (!_isInitialized || _logSink == null) {
        return;
      }

      // Check if rotation needed
      final fileSize = await _currentLogFile?.length() ?? 0;
      if (fileSize >= _maxFileSize) {
        await _rotateLogFile();
      }

      // Write log entry
      if (_format == LogFormat.console) {
        final timeStr = _formatTimestamp(timestamp);
        _logSink?.writeln(
          '[$timeStr] [$severity] $className.$methodName: $message',
        );
      } else {
        final json = _buildJsonLog(
          severity,
          className,
          methodName,
          message,
          timestamp,
          false,
        );
        _logSink?.writeln(jsonEncode(json));
      }
    } catch (e) {
      debugPrint('AppLogger file write error: $e');
    }
  }

  /// Initializes the log file in the app's documents directory.
  /// Creates logs subdirectory if it doesn't exist.
  static Future<void> _initializeLogFile() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${docsDir.path}/logs');

      // Create logs directory if it doesn't exist
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      // Create new log file with timestamp
      final timestamp = DateTime.now();
      final filename = 'app_log_${_formatFilenameTimestamp(timestamp)}.log';
      _currentLogFile = File('${logsDir.path}/$filename');

      // Open file for writing
      _logSink = _currentLogFile!.openWrite(mode: FileMode.append);

      // Clean up old files
      await _cleanupOldFiles(logsDir);
    } catch (e) {
      debugPrint('AppLogger initialization error: $e');
    }
  }

  /// Rotates to a new log file when size limit is reached.
  /// Closes current file and creates new one with timestamp.
  static Future<void> _rotateLogFile() async {
    try {
      // Close current file
      await _logSink?.close();

      // Create new file
      await _initializeLogFile();
    } catch (e) {
      debugPrint('AppLogger rotation error: $e');
    }
  }

  /// Deletes oldest log files when count exceeds maximum.
  /// Keeps only the most recent [_maxFiles] files.
  static Future<void> _cleanupOldFiles(Directory logsDir) async {
    try {
      final files = await logsDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.log'))
          .cast<File>()
          .toList();

      // Sort by modification time (oldest first)
      files.sort(
        (a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()),
      );

      // Delete oldest files if we exceed max count
      if (files.length > _maxFiles) {
        final filesToDelete = files.take(files.length - _maxFiles);
        for (final file in filesToDelete) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('AppLogger cleanup error: $e');
    }
  }

  /// Formats timestamp for console/file output.
  /// Format: YYYY-MM-DD HH:mm:ss.SSS
  static String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  /// Formats timestamp for filename.
  /// Format: YYYY_MM_DD_HH_mm_ss (sortable)
  static String _formatFilenameTimestamp(DateTime timestamp) {
    return '${timestamp.year}_${timestamp.month.toString().padLeft(2, '0')}_${timestamp.day.toString().padLeft(2, '0')}_'
        '${timestamp.hour.toString().padLeft(2, '0')}_${timestamp.minute.toString().padLeft(2, '0')}_${timestamp.second.toString().padLeft(2, '0')}';
  }

  /// Builds JSON log object for structured logging.
  /// Includes timestamp, severity, class, method, message, and throttled flag.
  static Map<String, dynamic> _buildJsonLog(
    String severity,
    String className,
    String methodName,
    String message,
    DateTime timestamp,
    bool throttled,
  ) {
    return {
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'class': className,
      'method': methodName,
      'message': message,
      'throttled': throttled,
    };
  }
}

/// Log severity levels in ascending order.
/// Used for filtering logs based on minimum severity.
enum LogLevel {
  /// Detailed debug information
  debug,

  /// General informational messages
  info,

  /// Warning messages for recoverable issues
  warning,

  /// Error messages for failures
  error,
}

/// Log output format options.
/// - console: Human-readable format for development (no file logging)
/// - json: Structured JSON format for parsing/analysis (with file logging)
enum LogFormat {
  /// Human-readable console format: [timestamp] [LEVEL] class.method: message
  /// Note: Console format does NOT create log files
  console,

  /// Structured JSON format with all fields
  /// Note: JSON format creates and rotates log files
  json,
}
