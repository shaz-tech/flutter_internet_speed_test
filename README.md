# flutter_internet_speed_test

A Flutter plugin to test internet download and upload speed.

## Get started

### Add dependency

```yaml
dependencies:
  flutter_internet_speed_test: ^1.0.2
```

### Screenshots

![Screenshot_20220928-191212](https://user-images.githubusercontent.com/8435335/192833714-1db9d67b-f4a1-4381-b2ba-6b400a0a1f2b.jpg) ![Screenshot_20220928-191117](https://user-images.githubusercontent.com/8435335/192833796-10f15bf1-38d0-483d-8d9b-990911cf412f.jpg)


### Example

```dart

    import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
    
    final speedTest = FlutterInternetSpeedTest();
    
    speedTest.startTesting(
        onDone: (TestResult download, TestResult upload) {
            // TODO: Change UI
        },
        onProgress: (double percent, TestResult data) {
            // TODO: Change UI
        },
        onError: (String errorMessage, String speedTestError) {
        // TODO: Show toast error
        }
    );

```

### Additional features

You can also configure your test server URL

```dart

  import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

  final speedTest = FlutterInternetSpeedTest();

  speedTest.startTesting(
     onDone: (TestResult download, TestResult upload) {
        // TODO: Change UI
     },
     onProgress: (double percent, TestResult data) {
        // TODO: Change UI
     },
     onError: (String errorMessage, String speedTestError) {
        // TODO: Show toast error
     },
     downloadTestServer: //Your download test server URL goes here,
     uploadTestServer: //Your upload test server URL goes here,
     fileSize: //File size to be tested
   );

```

If you don't provide a customized server URL we'll be using this URL for downloading
http://ipv4.ikoula.testdebit.info/1M.iso

And this for uploading
http://ipv4.ikoula.testdebit.info/

### Platforms

The package is working on both platforms iOS & Android!

### Shoutout

Shoutout to [JSpeedTest](https://github.com/bertrandmartel/speed-test-lib)