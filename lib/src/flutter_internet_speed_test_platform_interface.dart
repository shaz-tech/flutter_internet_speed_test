import 'package:flutter/foundation.dart';
import 'package:flutter_internet_speed_test/src/models/server_selection_response.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tuple_dart/tuple.dart';

import 'callbacks_enum.dart';
import 'flutter_internet_speed_test_method_channel.dart';

typedef CancelListening = void Function();
typedef DoneCallback = void Function(double transferRate, SpeedUnit unit);
typedef ProgressCallback = void Function(
  double percent,
  double transferRate,
  SpeedUnit unit,
);
typedef ErrorCallback = void Function(
    String errorMessage, String speedTestError);
typedef CancelCallback = void Function();

abstract class FlutterInternetSpeedTestPlatform extends PlatformInterface {
  /// Constructs a FlutterInternetSpeedTestPlatform.
  FlutterInternetSpeedTestPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterInternetSpeedTestPlatform _instance =
      MethodChannelFlutterInternetSpeedTest();

  /// The default instance of [FlutterInternetSpeedTestPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterInternetSpeedTest].
  static FlutterInternetSpeedTestPlatform get instance => _instance;

  Map<int,
          Tuple4<ErrorCallback, ProgressCallback, DoneCallback, CancelCallback>>
      callbacksById = {};
  int downloadRate = 0;
  int uploadRate = 0;
  int downloadSteps = 0;
  int uploadSteps = 0;

  bool logEnabled = false;

  get isLogEnabled => logEnabled && kDebugMode;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterInternetSpeedTestPlatform] when
  /// they register themselves.
  static set instance(FlutterInternetSpeedTestPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required CancelCallback onCancel,
      required int fileSize,
      required String testServer}) {
    throw UnimplementedError(
        'startDownloadTesting() has not been implemented.');
  }

  Future<CancelListening> startUploadTesting({
    required DoneCallback onDone,
    required ProgressCallback onProgress,
    required ErrorCallback onError,
    required CancelCallback onCancel,
    required int fileSize,
    required String testServer,
  }) {
    throw UnimplementedError('startUploadTesting() has not been implemented.');
  }

  Future<void> toggleLog({
    required bool value,
  }) {
    throw UnimplementedError('toggleLog() has not been implemented.');
  }

  Future<ServerSelectionResponse?> getDefaultServer() {
    throw UnimplementedError('getDefaultServer() has not been implemented.');
  }

  Future<bool> cancelTest() {
    throw UnimplementedError('cancelTest() has not been implemented.');
  }
}
