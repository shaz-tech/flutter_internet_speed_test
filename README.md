# flutter_internet_speed_test

A Flutter plugin to test internet download and upload speed.

#### Used servers: 
Fast.com by Netflix (default), Speed Test by Ookla

## Get started

### Add dependency

```yaml
dependencies:
  flutter_internet_speed_test: ^lastest_version
```

### Screenshots

![Screenshot_20221121-112052~2-1](https://user-images.githubusercontent.com/8435335/202976318-2fe97441-ee8f-4545-bf19-0245491c4c08.jpg)

### Example

```dart

    import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
    
    final speedTest = FlutterInternetSpeedTest();
    speedTest.startTesting(
        onStarted: () {
          // TODO
        },
        onCompleted: (TestResult download, TestResult upload) {
          // TODO
        },
        onProgress: (double percent, TestResult data) {
          // TODO
        },
        onError: (String errorMessage, String speedTestError) {
          // TODO
        },
        onDefaultServerSelectionInProgress: () {
          // TODO
          //Only when you use useFastApi parameter as true(default)
        },
        onDefaultServerSelectionDone: (Client? client) {
          // TODO
          //Only when you use useFastApi parameter as true(default)
        },
        onDownloadComplete: (TestResult data) {
          // TODO
        },
        onUploadComplete: (TestResult data) {
          // TODO
        },
    );

```

### Additional features

You can also configure your test server URL

```dart

  import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

  final speedTest = FlutterInternetSpeedTest();
  speedTest.startTesting(
      useFastApi: true/false
      downloadTestServer: //Your download test server URL goes here,
      uploadTestServer: //Your upload test server URL goes here,
      fileSize: //File size to be tested
      onStarted: () {
        // TODO
      },
      onCompleted: (TestResult download, TestResult upload) {
        // TODO
      },
      onProgress: (double percent, TestResult data) {
        // TODO
      },
      onError: (String errorMessage, String speedTestError) {
        // TODO
      },
      onDefaultServerSelectionInProgress: () {
        // TODO
        //Only when you use useFastApi parameter as true(default)
      },
      onDefaultServerSelectionDone: (Client? client) {
        // TODO
        ///Only when you use useFastApi parameter as true(default)
      },
      onDownloadComplete: (TestResult data) {
        // TODO
      },
      onUploadComplete: (TestResult data) {
        // TODO
      },
  );

```

If you don't provide a customized server URL we'll be using this URL for downloading as per the availability

1.https://fast.com/

2.http://speedtest.ftp.otenet.gr/files/test1Mb.db


If you don't provide a customized server URL we'll be using this URL for uploading as per the availability

1.https://fast.com/

2.http://speedtest.ftp.otenet.gr/

### Platforms

The package is working on both platforms iOS & Android!
