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
  final internetSpeedTest =
      FlutterInternetSpeedTest(); //FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;

  String _unitText = 'Mb/s';

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
                  Text('Progress: $_downloadProgress%'),
                  Text('Download Rate: $_downloadRate $_unitText'),
                  if (_downloadCompletionTime > 0)
                    Text(
                        'Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
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
                  Text('Progress: $_uploadProgress%'),
                  Text('Upload Rate: $_uploadRate $_unitText'),
                  if (_uploadCompletionTime > 0)
                    Text(
                        'Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              if (!_testInProgress) ...{
                ElevatedButton(
                  child: const Text('Start Testing'),
                  onPressed: () async {
                    reset();
                    final started = await internetSpeedTest.startTesting(
                      onDone: (TestResult download, TestResult upload) {
                        if (internetSpeedTest.isLogEnabled) {
                          print(
                              'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                        }
                        setState(() {
                          _downloadRate = download.transferRate;
                          _unitText =
                              download.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          _downloadProgress = '100';
                          _downloadCompletionTime = download.durationInMillis;
                        });
                        setState(() {
                          _uploadRate = upload.transferRate;
                          _unitText =
                              upload.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          _uploadProgress = '100';
                          _uploadCompletionTime = upload.durationInMillis;
                          _testInProgress = false;
                        });
                      },
                      onProgress: (double percent, TestResult data) {
                        if (internetSpeedTest.isLogEnabled) {
                          print(
                              'the transfer rate $data.transferRate, the percent $percent');
                        }
                        setState(() {
                          _unitText =
                              data.unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
                          if (data.type == TestType.DOWNLOAD) {
                            _downloadRate = data.transferRate;
                            _downloadProgress = percent.toStringAsFixed(2);
                          } else {
                            _uploadRate = data.transferRate;
                            _uploadProgress = percent.toStringAsFixed(2);
                          }
                        });
                      },
                      onError: (String errorMessage, String speedTestError) {
                        if (internetSpeedTest.isLogEnabled) {
                          print(
                              'the errorMessage $errorMessage, the speedTestError $speedTestError');
                        }
                        reset();
                      },
                    );
                    setState(() => _testInProgress = started);
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
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _downloadProgress = '0';
        _uploadProgress = '0';
        _unitText = 'Mb/s';
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;
      }
    });
  }
}
