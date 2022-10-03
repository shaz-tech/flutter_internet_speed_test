import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tuple_dart/tuple.dart';

import 'callbacks_enum.dart';
import 'flutter_internet_speed_test_platform_interface.dart';

/// An implementation of [FlutterInternetSpeedTestPlatform] that uses method channels.
class MethodChannelFlutterInternetSpeedTest
    extends FlutterInternetSpeedTestPlatform {
  /// The method channel used to interact with the native platform.
  final _channel = const MethodChannel('com.shaz.plugin.fist/method');

  Future<void> _methodCallHandler(MethodCall call) async {
    if (isLogEnabled) {
      print('arguments are ${call.arguments}');
//    print('arguments type is  ${call.arguments['type']}');
      print('callbacks are $callbacksById');
    }
    switch (call.method) {
      case 'callListener':
        if (call.arguments["id"] as int ==
            CallbacksEnum.START_DOWNLOAD_TESTING.index) {
          if (call.arguments['type'] == ListenerEnum.COMPLETE.index) {
            downloadSteps++;
            downloadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());
            if (isLogEnabled) {
              print('download steps is $downloadSteps}');
              print('download steps is $downloadRate}');
            }
            double average = (downloadRate ~/ downloadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.Kbps;
            average /= 1000;
            unit = SpeedUnit.Mbps;
            callbacksById[call.arguments["id"]]!.item3(average, unit);
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.ERROR.index) {
            if (isLogEnabled) {
              print('onError : ${call.arguments["speedTestError"]}');
              print('onError : ${call.arguments["errorMessage"]}');
            }
            callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
            downloadSteps = 0;
            downloadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.PROGRESS.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            if (isLogEnabled) {
              print('rate is $rate');
            }
            if (rate != 0) downloadSteps++;
            downloadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.Kbps;
            rate /= 1000;
            unit = SpeedUnit.Mbps;
            callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          }
        } else if (call.arguments["id"] as int ==
            CallbacksEnum.START_UPLOAD_TESTING.index) {
          if (call.arguments['type'] == ListenerEnum.COMPLETE.index) {
            if (isLogEnabled) {
              print('onComplete : ${call.arguments['transferRate']}');
            }

            uploadSteps++;
            uploadRate +=
                int.parse((call.arguments['transferRate'] ~/ 1000).toString());
            if (isLogEnabled) {
              print('download steps is $uploadSteps}');
              print('download steps is $uploadRate}');
            }
            double average = (uploadRate ~/ uploadSteps).toDouble();
            SpeedUnit unit = SpeedUnit.Kbps;
            average /= 1000;
            unit = SpeedUnit.Mbps;
            callbacksById[call.arguments["id"]]!.item3(average, unit);
            uploadSteps = 0;
            uploadRate = 0;
            callbacksById.remove(call.arguments["id"]);
          } else if (call.arguments['type'] == ListenerEnum.ERROR.index) {
            if (isLogEnabled) {
              print('onError : ${call.arguments["speedTestError"]}');
              print('onError : ${call.arguments["errorMessage"]}');
            }
            callbacksById[call.arguments["id"]]!.item1(
                call.arguments['errorMessage'],
                call.arguments['speedTestError']);
          } else if (call.arguments['type'] == ListenerEnum.PROGRESS.index) {
            double rate = (call.arguments['transferRate'] ~/ 1000).toDouble();
            if (isLogEnabled) {
              print('rate is $rate');
            }
            if (rate != 0) uploadSteps++;
            uploadRate += rate.toInt();
            SpeedUnit unit = SpeedUnit.Kbps;
            rate /= 1000.0;
            unit = SpeedUnit.Mbps;
            callbacksById[call.arguments["id"]]!
                .item2(call.arguments['percent'].toDouble(), rate, unit);
          }
        }
//        callbacksById[call.arguments["id"]](call.arguments["args"]);
        break;
      default:
        if (isLogEnabled) {
          print(
              'TestFairy: Ignoring invoke from native. This normally shouldn\'t happen.');
        }
    }

    _channel.invokeMethod("cancelListening", call.arguments["id"]);
  }

  Future<CancelListening> _startListening(
      Tuple3<ErrorCallback, ProgressCallback, DoneCallback> callback,
      CallbacksEnum callbacksEnum,
      String testServer,
      {Map<String, dynamic>? args,
      int fileSize = 200000}) async {
    _channel.setMethodCallHandler(_methodCallHandler);
    int currentListenerId = callbacksEnum.index;
    if (isLogEnabled) {
      print('test $currentListenerId');
    }
    callbacksById[currentListenerId] = callback;
    await _channel.invokeMethod(
      "startListening",
      {
        'id': currentListenerId,
        'args': args,
        'testServer': testServer,
        'fileSize': fileSize,
      },
    );
    return () {
      _channel.invokeMethod("cancelListening", currentListenerId);
      callbacksById.remove(currentListenerId);
    };
  }

  Future<void> _toggleLog(bool value) async {
    await _channel.invokeMethod(
      "toggleLog",
      {
        'value': value,
      },
    );
  }

  @override
  Future<CancelListening> startDownloadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required fileSize,
      required String testServer}) async {
    return await _startListening(Tuple3(onError, onProgress, onDone),
        CallbacksEnum.START_DOWNLOAD_TESTING, testServer,
        fileSize: fileSize);
  }

  @override
  Future<CancelListening> startUploadTesting(
      {required DoneCallback onDone,
      required ProgressCallback onProgress,
      required ErrorCallback onError,
      required int fileSize,
      required String testServer}) async {
    return await _startListening(Tuple3(onError, onProgress, onDone),
        CallbacksEnum.START_UPLOAD_TESTING, testServer,
        fileSize: fileSize);
  }

  @override
  Future<void> toggleLog({required bool value}) async {
    logEnabled = value;
    await _toggleLog(logEnabled);
  }
}
