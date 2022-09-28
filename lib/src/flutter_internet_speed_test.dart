import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_internet_speed_test/src/test_result.dart';

import 'callbacks_enum.dart';
import 'flutter_internet_speed_test_platform_interface.dart';

typedef ResultCallback = void Function(TestResult download, TestResult upload);
typedef TestProgressCallback = void Function(double percent, TestResult data);

class FlutterInternetSpeedTest {
  static final FlutterInternetSpeedTest _instance =
      FlutterInternetSpeedTest._private();

  bool _isTestInProgress = false;

  factory FlutterInternetSpeedTest() => _instance;

  FlutterInternetSpeedTest._private();

  bool isTestInProgress() => _isTestInProgress;

  Future<bool> startTesting({
    required ResultCallback onDone,
    required TestProgressCallback onProgress,
    required ErrorCallback onError,
    String downloadTestServer = 'http://ipv4.ikoula.testdebit.info/1M.iso',
    String uploadTestServer = 'http://ipv4.ikoula.testdebit.info/',
    int fileSize = 200000,
  }) async {
    if (_isTestInProgress) {
      return false;
    }
    if (await isInternetAvailable() == false) {
      return false;
    }
    _isTestInProgress = true;
    FlutterInternetSpeedTestPlatform.instance.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        final downloadResult =
            TestResult(TestType.DOWNLOAD, transferRate, unit);
        FlutterInternetSpeedTestPlatform.instance.startUploadTesting(
          onDone: (double transferRate, SpeedUnit unit) {
            final uploadResult =
                TestResult(TestType.UPLOAD, transferRate, unit);
            onDone(downloadResult, uploadResult);
            _isTestInProgress = false;
          },
          onProgress: (double percent, double transferRate, SpeedUnit unit) {
            final uploadProgressResult =
                TestResult(TestType.UPLOAD, transferRate, unit);
            onProgress(percent, uploadProgressResult);
          },
          onError: (String errorMessage, String speedTestError) {
            onError(errorMessage, speedTestError);
            _isTestInProgress = false;
          },
          fileSize: fileSize,
          testServer: uploadTestServer,
        );
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        final downloadProgressResult =
            TestResult(TestType.DOWNLOAD, transferRate, unit);
        onProgress(percent, downloadProgressResult);
      },
      onError: (String errorMessage, String speedTestError) {
        onError(errorMessage, speedTestError);
        _isTestInProgress = false;
      },
      fileSize: fileSize,
      testServer: downloadTestServer,
    );
    return true;
  }

  Future<bool> isInternetAvailable() async {
    final connectivity = Connectivity();
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}
