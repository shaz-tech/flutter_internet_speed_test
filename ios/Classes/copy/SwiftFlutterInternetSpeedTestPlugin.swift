import Flutter
import UIKit

public class SwiftFlutterInternetSpeedTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_internet_speed_test", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterInternetSpeedTestPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
