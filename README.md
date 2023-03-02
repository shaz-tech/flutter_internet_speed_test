<div align="center">

# Flutter Internet Speed Test

[![Flutter](https://img.shields.io/badge/_Flutter_-Plugin-grey.svg?&logo=Flutter&logoColor=white&labelColor=blue)](https://pub.dev/packages/flutter_internet_speed_test)
[![Pub Version](https://img.shields.io/pub/v/flutter_internet_speed_test?color=orange&label=version)](https://pub.dev/packages/flutter_internet_speed_test)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/shaz-tech/flutter_internet_speed_test?color=blueviolet)](https://pub.dev/packages/flutter_internet_speed_test)
[![GitHub](https://img.shields.io/github/license/shaz-tech/flutter_internet_speed_test)](https://pub.dev/packages/flutter_internet_speed_test)
 
</div>
A Flutter plugin to test internet download and upload speed.

#### Servers used:

1. Fast.com by Netflix (default)

2. Speed Test by Ookla

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
        useFastApi: true/false //true(default)
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
        onCancel: () {
        // TODO Request cancelled callback
        },
    );

```

### Additional features

You can also configure your test server URL

```dart

  import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

  final speedTest = FlutterInternetSpeedTest();
  speedTest.startTesting(
      useFastApi: true/false //true(default)
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
      onCancel: () {
        // TODO Request cancelled callback
      },
  );

```

If you don't provide a customized server URL we'll be using this URL for downloading as per the
availability

1.https://fast.com/

2.http://speedtest.ftp.otenet.gr/files/test1Mb.db

If you don't provide a customized server URL we'll be using this URL for uploading as per the
availability

1.https://fast.com/

2.http://speedtest.ftp.otenet.gr/

### Platforms

The package is working on both platforms iOS & Android!
