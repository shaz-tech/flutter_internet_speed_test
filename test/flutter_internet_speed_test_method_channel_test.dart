import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //MethodChannelFlutterInternetSpeedTest platform = MethodChannelFlutterInternetSpeedTest();
  const MethodChannel channel = MethodChannel('flutter_internet_speed_test');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  /*test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });*/
}
