/*class MockFlutterInternetSpeedTestPlatform
    with MockPlatformInterfaceMixin
    implements FlutterInternetSpeedTestPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterInternetSpeedTestPlatform initialPlatform = FlutterInternetSpeedTestPlatform.instance;

  test('$MethodChannelFlutterInternetSpeedTest is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterInternetSpeedTest>());
  });

  test('getPlatformVersion', () async {
    FlutterInternetSpeedTest flutterInternetSpeedTestPlugin = FlutterInternetSpeedTest();
    MockFlutterInternetSpeedTestPlatform fakePlatform = MockFlutterInternetSpeedTestPlatform();
    FlutterInternetSpeedTestPlatform.instance = fakePlatform;
  
    expect(await flutterInternetSpeedTestPlugin.getPlatformVersion(), '42');
  });
}*/
