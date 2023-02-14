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
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  bool _isServerSelectionInProgress = false;

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(_isServerSelectionInProgress
                    ? 'Selecting Server...'
                    : 'IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}'),
              ),
              if (!_testInProgress) ...{
                ElevatedButton(
                  child: const Text('Start Testing'),
                  onPressed: () async {
                    reset();
                    await internetSpeedTest.startTesting(onStarted: () {
                      setState(() => _testInProgress = true);
                    }, onCompleted: (TestResult download, TestResult upload) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                      }
                      setState(() {
                        _downloadRate = download.transferRate;
                        _unitText =
                            download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadProgress = '100';
                        _downloadCompletionTime = download.durationInMillis;
                      });
                      setState(() {
                        _uploadRate = upload.transferRate;
                        _unitText =
                            upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadProgress = '100';
                        _uploadCompletionTime = upload.durationInMillis;
                        _testInProgress = false;
                      });
                    }, onProgress: (double percent, TestResult data) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate $data.transferRate, the percent $percent');
                      }
                      setState(() {
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        if (data.type == TestType.download) {
                          _downloadRate = data.transferRate;
                          _downloadProgress = percent.toStringAsFixed(2);
                        } else {
                          _uploadRate = data.transferRate;
                          _uploadProgress = percent.toStringAsFixed(2);
                        }
                      });
                    }, onError: (String errorMessage, String speedTestError) {
                      if (kDebugMode) {
                        print(
                            'the errorMessage $errorMessage, the speedTestError $speedTestError');
                      }
                      reset();
                    }, onDefaultServerSelectionInProgress: () {
                      setState(() {
                        _isServerSelectionInProgress = true;
                      });
                    }, onDefaultServerSelectionDone: (Client? client) {
                      setState(() {
                        _isServerSelectionInProgress = false;
                        _ip = client?.ip;
                        _asn = client?.asn;
                        _isp = client?.isp;
                      });
                    }, onDownloadComplete: (TestResult data) {
                      setState(() {
                        _downloadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadCompletionTime = data.durationInMillis;
                      });
                    }, onUploadComplete: (TestResult data) {
                      setState(() {
                        _uploadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadCompletionTime = data.durationInMillis;
                      });
                    }, onCancel: () {
                      reset();
                    });
                  },
                )
              } else ...{
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => internetSpeedTest.cancelTest(),
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel'),
                  ),
                )
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
        _unitText = 'Mbps';
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;

        _ip = null;
        _asn = null;
        _isp = null;
      }
    });
  }
}
