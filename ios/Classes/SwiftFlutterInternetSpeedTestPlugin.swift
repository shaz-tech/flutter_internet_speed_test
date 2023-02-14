import Flutter
import UIKit

public class SwiftInternetSpeedTestPlugin: NSObject, FlutterPlugin {
    let DEFAULT_FILE_SIZE = 10485760
    let DEFAULT_TEST_TIMEOUT = 20000
    
    var callbackById: [Int: () -> ()] = [:]
    
    let speedTest = SpeedTest()
    static var channel: FlutterMethodChannel!
    
    private let logger = Logger()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "com.shaz.plugin.fist/method", binaryMessenger: registrar.messenger())
        
        let instance = SwiftInternetSpeedTestPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private func mapToCall(result: FlutterResult, arguments: Any?) {
        let argsMap = arguments as! [String: Any]
        let args = argsMap["id"] as! Int
        var fileSize = DEFAULT_FILE_SIZE
        if let fileSizeArgument = argsMap["fileSize"] as? Int {
            fileSize = fileSizeArgument
        }
        logger.printLog(message: "file is of size \(fileSize) Bytes")
        switch args {
        case 0:
            startListening(args: args, flutterResult: result, methodName: "startDownloadTesting", testServer: argsMap["testServer"] as! String, fileSize: fileSize)
            break
        case 1:
            startListening(args: args, flutterResult: result, methodName: "startUploadTesting", testServer: argsMap["testServer"] as! String, fileSize: fileSize)
            break
        default:
            break
        }
    }
    
    private func toggleLog(result: FlutterResult, arguments: Any?) {
        let argsMap = arguments as! [String: Any]
        if(argsMap["value"] != nil){
            let logValue = argsMap["value"] as! Bool
            logger.enabled = logValue
        }
    }
    
    private func cancelTasks(result: FlutterResult, arguments: Any?) {
        self.speedTest.cancelTasks()
        result(true)
    }
    
    func startListening(args: Any, flutterResult: FlutterResult, methodName:String, testServer: String, fileSize: Int) {
        logger.printLog(message: "Method name is \(methodName)")
        let currentListenerId = args as! Int
        logger.printLog(message: "id is \(currentListenerId)")
        
        let fun = {
            if (self.callbackById.contains(where: { (key, _) -> Bool in
                self.logger.printLog(message: "does contain key \(key == currentListenerId)")
                return key == currentListenerId
            })) {
                self.logger.printLog(message: "inside if")
                switch methodName {
                case "startDownloadTesting" :
                    self.speedTest.runDownloadTest(for: URL(string: testServer)!, size: fileSize, timeout: TimeInterval(self.DEFAULT_TEST_TIMEOUT), current: { (currentSpeed) in
                        var argsMap: [String: Any] = [:]
                        argsMap["id"] = currentListenerId
                        argsMap["transferRate"] = self.getSpeedInBytes(speed: currentSpeed)
                        argsMap["percent"] = 50
                        argsMap["type"] = 2
                        DispatchQueue.main.async {
                            SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                        }
                    }, final: { (resultSpeed) in
                        switch resultSpeed {
                        case .value(let finalSpeed):
                            var argsMap: [String: Any] = [:]
                            argsMap["id"] = currentListenerId
                            argsMap["transferRate"] = self.getSpeedInBytes(speed: finalSpeed)
                            argsMap["percent"] = 100
                            argsMap["type"] = 0
                            DispatchQueue.main.async {
                                SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                            }
                        case .error(let error):
                            self.logger.printLog(message: "Error is \(error.localizedDescription)")
                            var argsMap: [String: Any] = [:]
                            argsMap["id"] = currentListenerId
                            argsMap["speedTestError"] = error.localizedDescription
                            argsMap["type"] = 1
                            DispatchQueue.main.async {
                                SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                            }
                        }
                    })
                    break
                    //                        case .error(let error):
                    //                            logger.printLog(message: "Error get url  is \(error.localizedDescription)")
                    //                            var argsMap: [String: Any] = [:]
                    //                            argsMap["id"] = currentListenerId
                    //                            argsMap["speedTestError"] = error.localizedDescription
                    //                            argsMap["type"] = 1
                    //
                    //                            SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                    //                        }
                    //                    }
                    
                    //                    break
                case "startUploadTesting":
                    self.speedTest.runUploadTest(for: URL(string: testServer)!, size: fileSize, timeout: TimeInterval(self.DEFAULT_TEST_TIMEOUT), current: { (currentSpeed) in
                        var argsMap: [String: Any] = [:]
                        argsMap["id"] = currentListenerId
                        argsMap["transferRate"] = self.getSpeedInBytes(speed: currentSpeed)
                        argsMap["percent"] = 50
                        argsMap["type"] = 2
                        DispatchQueue.main.async {
                            SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                        }
                    }, final: { (resultSpeed) in
                        switch resultSpeed {
                            
                        case .value(let finalSpeed):
                            
                            var argsMap: [String: Any] = [:]
                            argsMap["id"] = currentListenerId
                            argsMap["transferRate"] = self.getSpeedInBytes(speed: finalSpeed)
                            argsMap["percent"] = 50
                            argsMap["type"] = 0
                            
                            DispatchQueue.main.async {
                                SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                            }
                        case .error(let error):
                            
                            self.logger.printLog(message: "Error is \(error.localizedDescription)")
                            
                            var argsMap: [String: Any] = [:]
                            argsMap["id"] = currentListenerId
                            argsMap["speedTestError"] = error.localizedDescription
                            argsMap["type"] = 1
                            DispatchQueue.main.async {
                                SwiftInternetSpeedTestPlugin.channel.invokeMethod("callListener", arguments: argsMap)
                            }
                        }
                    })
                    break
                default:
                    break
                }
            }
        }
        callbackById[currentListenerId] = fun
        fun()
    }
    
    func getSpeedInBytes(speed: Speed) -> Double {
        var rate = speed.value
        if speed.units == .Kbps {
            rate = rate * 1000
        } else if speed.units == .Mbps {
            rate = rate * 1000 * 1000
        } else  {
            rate = rate * 1000 * 1000 * 1000
        }
        return rate
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "startListening") {
            mapToCall(result: result, arguments: call.arguments)
        } else if (call.method == "cancelListening") {
            //cancelListening(arguments: call.arguments, result: result)
        } else if (call.method == "toggleLog") {
            toggleLog(result: result, arguments: call.arguments)
        }else if (call.method == "cancelTest") {
            cancelTasks(result: result, arguments: call.arguments)
        }
    }
    
    class Logger{
        var enabled = false
        
        func printLog(message: String){
            if(enabled){
                print(message)
            }
        }
    }
    
}
