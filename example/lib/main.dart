import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final internetSpeedTest = FlutterInternetSpeedTest();

  bool testInProgress = false;
  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';

  String unitText = 'Mb/s';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterInternetSpeedTest example'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Download Speed',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Progress: $downloadProgress%'),
                  Text('Download Rate: $downloadRate $unitText'),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Upload Speed',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Progress: $uploadProgress%'),
                  Text('Upload Rate: $uploadRate $unitText'),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              if (!testInProgress) ...{
                ElevatedButton(
                  child: const Text('Start Testing'),
                  onPressed: () async {
                    reset();
                    final started = await internetSpeedTest.startTesting(
                      onDone: (TestResult download, TestResult upload) {
                        if (kDebugMode) {
                          print(
                              'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                        }
                        setState(() {
                          downloadRate = download.transferRate;
                          unitText =
                              download.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          downloadProgress = '100';
                          testInProgress = false;
                        });
                        setState(() {
                          uploadRate = upload.transferRate;
                          unitText =
                              upload.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          uploadProgress = '100';
                        });
                      },
                      onProgress: (double percent, TestResult data) {
                        if (kDebugMode) {
                          print(
                              'the transfer rate $data.transferRate, the percent $percent');
                        }
                        setState(() {
                          unitText =
                              data.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          if (data.type == TestType.DOWNLOAD) {
                            downloadRate = data.transferRate;
                            downloadProgress = percent.toStringAsFixed(2);
                          } else {
                            uploadRate = data.transferRate;
                            uploadProgress = percent.toStringAsFixed(2);
                          }
                        });
                      },
                      onError: (String errorMessage, String speedTestError) {
                        if (kDebugMode) {
                          print(
                              'the errorMessage $errorMessage, the speedTestError $speedTestError');
                        }
                        reset();
                      },
                    );
                    setState(() => testInProgress = started);
                  },
                )
              } else ...{
                const CircularProgressIndicator(),
              },
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      {
        testInProgress = false;
        downloadRate = 0;
        uploadRate = 0;
        downloadProgress = '0';
        uploadProgress = '0';
        unitText = 'Mb/s';
      }
    });
  }
}
