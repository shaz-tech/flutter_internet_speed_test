import 'package:flutter_internet_speed_test/src/speed_test_utils.dart';
import 'package:flutter_internet_speed_test/src/test_result.dart';

import 'callbacks_enum.dart';
import 'flutter_internet_speed_test_platform_interface.dart';
import 'models/server_selection_response.dart';

typedef DefaultCallback = void Function();
typedef ResultCallback = void Function(TestResult download, TestResult upload);
typedef TestProgressCallback = void Function(double percent, TestResult data);
typedef ResultCompletionCallback = void Function(TestResult data);
typedef DefaultServerSelectionCallback = void Function(Client? clinet);

class FlutterInternetSpeedTest {
  static const _defaultDownloadTestServer =
      'http://speedtest.ftp.otenet.gr/files/test1Mb.db';
  static const _defaultUploadTestServer = 'http://speedtest.ftp.otenet.gr/';

  static final FlutterInternetSpeedTest _instance =
      FlutterInternetSpeedTest._private();

  bool _isTestInProgress = false;

  factory FlutterInternetSpeedTest() => _instance;

  FlutterInternetSpeedTest._private();

  bool isTestInProgress() => _isTestInProgress;

  Future<bool> startTesting({
    required DefaultCallback? onStarted,
    required ResultCallback onCompleted,
    required ResultCompletionCallback? onDownloadComplete,
    required ResultCompletionCallback? onUploadComplete,
    required TestProgressCallback? onProgress,
    required DefaultCallback? onDefaultServerSelectionInProgress,
    required DefaultServerSelectionCallback? onDefaultServerSelectionDone,
    required ErrorCallback? onError,
    String? downloadTestServer,
    String? uploadTestServer,
    int fileSize = 200000,
    bool useFastApi = true,
  }) async {
    if (_isTestInProgress) {
      return false;
    }
    if (await isInternetAvailable() == false) {
      return false;
    }

    _isTestInProgress = true;
    if (onStarted != null) onStarted();

    if ((downloadTestServer == null || uploadTestServer == null) && useFastApi) {
      if (onDefaultServerSelectionInProgress != null) {
        onDefaultServerSelectionInProgress();
      }
      final serverSelectionResponse =
          await FlutterInternetSpeedTestPlatform.instance.getDefaultServer();
      if (onDefaultServerSelectionDone != null) {
        onDefaultServerSelectionDone(serverSelectionResponse?.client);
      }
      String? url = serverSelectionResponse?.targets?.first.url;
      if (url != null) {
        downloadTestServer = downloadTestServer ?? url;
        uploadTestServer = uploadTestServer ?? url;
      }
    }
    if (downloadTestServer == null || uploadTestServer == null) {
      downloadTestServer = downloadTestServer ?? _defaultDownloadTestServer;
      uploadTestServer = uploadTestServer ?? _defaultUploadTestServer;
    }

    final startDownloadTimeStamp = DateTime.now().millisecondsSinceEpoch;
    FlutterInternetSpeedTestPlatform.instance.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        final downloadDuration =
            DateTime.now().millisecondsSinceEpoch - startDownloadTimeStamp;
        final downloadResult = TestResult(TestType.DOWNLOAD, transferRate, unit,
            durationInMillis: downloadDuration);

        if (onProgress != null) onProgress(100, downloadResult);
        if (onDownloadComplete != null) onDownloadComplete(downloadResult);

        final startUploadTimeStamp = DateTime.now().millisecondsSinceEpoch;
        FlutterInternetSpeedTestPlatform.instance.startUploadTesting(
          onDone: (double transferRate, SpeedUnit unit) {
            final uploadDuration =
                DateTime.now().millisecondsSinceEpoch - startUploadTimeStamp;
            final uploadResult = TestResult(TestType.UPLOAD, transferRate, unit,
                durationInMillis: uploadDuration);

            if (onProgress != null) onProgress(100, uploadResult);
            if (onUploadComplete != null) onUploadComplete(uploadResult);

            onCompleted(downloadResult, uploadResult);
            _isTestInProgress = false;
          },
          onProgress: (double percent, double transferRate, SpeedUnit unit) {
            final uploadProgressResult =
                TestResult(TestType.UPLOAD, transferRate, unit);
            if (onProgress != null) onProgress(percent, uploadProgressResult);
          },
          onError: (String errorMessage, String speedTestError) {
            if (onError != null) onError(errorMessage, speedTestError);
            _isTestInProgress = false;
          },
          fileSize: fileSize,
          testServer: uploadTestServer!,
        );
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        final downloadProgressResult =
            TestResult(TestType.DOWNLOAD, transferRate, unit);
        if (onProgress != null) onProgress(percent, downloadProgressResult);
      },
      onError: (String errorMessage, String speedTestError) {
        if (onError != null) onError(errorMessage, speedTestError);
        _isTestInProgress = false;
      },
      fileSize: fileSize,
      testServer: downloadTestServer,
    );

    return true;
  }

  void enableLog() {
    FlutterInternetSpeedTestPlatform.instance.toggleLog(value: true);
  }

  void disableLog() {
    FlutterInternetSpeedTestPlatform.instance.toggleLog(value: false);
  }

  bool get isLogEnabled => FlutterInternetSpeedTestPlatform.instance.logEnabled;
}
