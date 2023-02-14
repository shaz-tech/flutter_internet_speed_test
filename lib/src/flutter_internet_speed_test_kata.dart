// import 'package:flutter_internet_speed_test/src/speed_test_utils.dart';
// import 'package:flutter_internet_speed_test/src/test_result.dart';
//
// import 'callbacks_enum.dart';
// import 'flutter_internet_speed_test_platform_interface.dart';
// import 'models/server_selection_response.dart';
//
// typedef DefaultCallback = void Function();
// typedef ResultCallback = void Function(TestResult download, TestResult upload);
// typedef TestProgressCallback = void Function(double percent, TestResult data);
// typedef ResultCompletionCallback = void Function(TestResult data);
// typedef DefaultServerSelectionCallback = void Function(Client? client);
// typedef CancelCallback = void Function(String? reason);
//
// class FlutterInternetSpeedTest {
//   static const _defaultDownloadTestServer =
//       'http://speedtest.ftp.otenet.gr/files/test1Mb.db';
//   static const _defaultUploadTestServer = 'http://speedtest.ftp.otenet.gr/';
//
//   static final FlutterInternetSpeedTest _instance =
//       FlutterInternetSpeedTest._private();
//
//   ResultCallback? onCompleted;
//   DefaultCallback? onStarted, onDefaultServerSelectionInProgress;
//   ResultCompletionCallback? onDownloadComplete, onUploadComplete;
//   TestProgressCallback? onProgress;
//   DefaultServerSelectionCallback? onDefaultServerSelectionDone;
//   ErrorCallback? onError;
//   CancelCallback? cancelCallback;
//
//   bool _isTestInProgress = false;
//
//   factory FlutterInternetSpeedTest() => _instance;
//
//   FlutterInternetSpeedTest._private();
//
//   bool isTestInProgress() => _isTestInProgress;
//
//   void addCallback({
//     required ResultCallback onCompleted,
//     DefaultCallback? onStarted,
//     ResultCompletionCallback? onDownloadComplete,
//     ResultCompletionCallback? onUploadComplete,
//     TestProgressCallback? onProgress,
//     DefaultCallback? onDefaultServerSelectionInProgress,
//     DefaultServerSelectionCallback? onDefaultServerSelectionDone,
//     ErrorCallback? onError,
//     CancelCallback? cancelCallback,
//   }) {
//     this.onCompleted = onCompleted;
//     this.onStarted = onStarted;
//     this.onDownloadComplete = onDownloadComplete;
//     this.onUploadComplete = onUploadComplete;
//     this.onProgress = onProgress;
//     this.onDefaultServerSelectionInProgress =
//         onDefaultServerSelectionInProgress;
//     this.onDefaultServerSelectionDone = onDefaultServerSelectionDone;
//     this.onError = onError;
//     this.cancelCallback = cancelCallback;
//   }
//
//   Future<bool> startTesting({
//     String? downloadTestServer,
//     String? uploadTestServer,
//     int fileSizeInBytes = 10000000, //10 MB
//     bool useFastApi = true,
//   }) async {
//     if (_isTestInProgress) {
//       return false;
//     }
//     if (await isInternetAvailable() == false) {
//       if (onError != null) {
//         onError!('No internet connection', 'No internet connection');
//       }
//       return false;
//     }
//
//     if (fileSizeInBytes < 10000000) fileSizeInBytes = 10000000; //10 MB
//     _isTestInProgress = true;
//     if (onStarted != null) onStarted!();
//
//     if ((downloadTestServer == null || uploadTestServer == null) &&
//         useFastApi) {
//       if (onDefaultServerSelectionInProgress != null) {
//         onDefaultServerSelectionInProgress!();
//       }
//       final serverSelectionResponse =
//           await FlutterInternetSpeedTestPlatform.instance.getDefaultServer();
//       if (onDefaultServerSelectionDone != null) {
//         onDefaultServerSelectionDone!(serverSelectionResponse?.client);
//       }
//       String? url = serverSelectionResponse?.targets?.first.url;
//       if (url != null) {
//         downloadTestServer = downloadTestServer ?? url;
//         uploadTestServer = uploadTestServer ?? url;
//       }
//     }
//     if (downloadTestServer == null || uploadTestServer == null) {
//       downloadTestServer = downloadTestServer ?? _defaultDownloadTestServer;
//       uploadTestServer = uploadTestServer ?? _defaultUploadTestServer;
//     }
//
//     final startDownloadTimeStamp = DateTime.now().millisecondsSinceEpoch;
//     FlutterInternetSpeedTestPlatform.instance.startDownloadTesting(
//       onDone: (double transferRate, SpeedUnit unit) {
//         final downloadDuration =
//             DateTime.now().millisecondsSinceEpoch - startDownloadTimeStamp;
//         final downloadResult = TestResult(TestType.DOWNLOAD, transferRate, unit,
//             durationInMillis: downloadDuration);
//
//         if (onProgress != null) onProgress!(100, downloadResult);
//         if (onDownloadComplete != null) onDownloadComplete!(downloadResult);
//
//         final startUploadTimeStamp = DateTime.now().millisecondsSinceEpoch;
//         FlutterInternetSpeedTestPlatform.instance.startUploadTesting(
//           onDone: (double transferRate, SpeedUnit unit) {
//             final uploadDuration =
//                 DateTime.now().millisecondsSinceEpoch - startUploadTimeStamp;
//             final uploadResult = TestResult(TestType.UPLOAD, transferRate, unit,
//                 durationInMillis: uploadDuration);
//
//             if (onProgress != null) onProgress!(100, uploadResult);
//             if (onUploadComplete != null) onUploadComplete!(uploadResult);
//
//             if (onCompleted != null) {
//               onCompleted!(downloadResult, uploadResult);
//             }
//             _isTestInProgress = false;
//           },
//           onProgress: (double percent, double transferRate, SpeedUnit unit) {
//             final uploadProgressResult =
//                 TestResult(TestType.UPLOAD, transferRate, unit);
//             if (onProgress != null) onProgress!(percent, uploadProgressResult);
//           },
//           onError: (String errorMessage, String speedTestError) {
//             if (onError != null) onError!(errorMessage, speedTestError);
//             _isTestInProgress = false;
//           },
//           fileSize: fileSizeInBytes,
//           testServer: uploadTestServer!,
//         );
//       },
//       onProgress: (double percent, double transferRate, SpeedUnit unit) {
//         final downloadProgressResult =
//             TestResult(TestType.DOWNLOAD, transferRate, unit);
//         if (onProgress != null) onProgress!(percent, downloadProgressResult);
//       },
//       onError: (String errorMessage, String speedTestError) {
//         if (onError != null) onError!(errorMessage, speedTestError);
//         _isTestInProgress = false;
//       },
//       fileSize: fileSizeInBytes,
//       testServer: downloadTestServer,
//     );
//
//     return true;
//   }
//
//   void enableLog() {
//     FlutterInternetSpeedTestPlatform.instance.toggleLog(value: true);
//   }
//
//   void disableLog() {
//     FlutterInternetSpeedTestPlatform.instance.toggleLog(value: false);
//   }
//
//   Future<bool> cancelTest() async {
//     final result = await FlutterInternetSpeedTestPlatform.instance.cancelTest();
//     if(cancelCallback != null){
//       cancelCallback()
//     }
//   }
//
//   bool get isLogEnabled => FlutterInternetSpeedTestPlatform.instance.logEnabled;
// }
