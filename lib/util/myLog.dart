import 'package:logger/logger.dart';

/// A Logger For Flutter Apps
/// Usage:
/// 1) AppLog.i("Info Message");
/// 2) AppLog.i("Home Page", tag: "User Logging");
class AppLog {
  static const String _DEFAULT_TAG_PREFIX = "SuperChat";
  static final _logger = Logger();

  static e(String msg) {
    _logger.e("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.info].
  static i(String msg) {
    _logger.i("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.debug].
  static d(String msg) {
    _logger.d("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.verbose].
  static v(String msg) {
    _logger.v("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.warning].
  static w(String msg) {
    _logger.w("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.wtf].
  static wtf(String msg) {
    _logger.wtf("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.fatal].
  static f(String msg) {
    _logger.f("$_DEFAULT_TAG_PREFIX: $msg");
  }

  /// Log a message at level [Level.trace].
  static t(String msg) {
    _logger.t("$_DEFAULT_TAG_PREFIX: $msg");
  }
}
