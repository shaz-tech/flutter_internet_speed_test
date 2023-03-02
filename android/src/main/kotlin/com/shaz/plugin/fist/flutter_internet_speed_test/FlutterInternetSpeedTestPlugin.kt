package com.shaz.plugin.fist.flutter_internet_speed_test

import android.app.Activity
import android.content.Context
import fr.bmartel.speedtest.SpeedTestReport
import fr.bmartel.speedtest.SpeedTestSocket
import fr.bmartel.speedtest.inter.IRepeatListener
import fr.bmartel.speedtest.inter.ISpeedTestListener
import fr.bmartel.speedtest.model.SpeedTestError
import fr.bmartel.speedtest.model.SpeedTestMode
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.TimeUnit

/** FlutterInternetSpeedTestPlugin */
class FlutterInternetSpeedTestPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val defaultFileSizeInBytes: Int = 10 * 1024 * 1024 //10 MB
    private val defaultTestTimeoutInMillis: Int = TimeUnit.SECONDS.toMillis(20).toInt()
    private val defaultResponseDelayInMillis: Int = TimeUnit.MILLISECONDS.toMillis(500).toInt()

    private var result: Result? = null
    private var speedTestSocket: SpeedTestSocket = SpeedTestSocket()

    private lateinit var methodChannel: MethodChannel
    private var activity: Activity? = null
    private var applicationContext: Context? = null

    private val logger = Logger()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        methodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "com.shaz.plugin.fist/method")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        print("FlutterInternetSpeedTestPlugin: onMethodCall: ${call.method}")
        this.result = result
        when (call.method) {
            "startListening" -> mapToCall(result, call.arguments)
            "cancelListening" -> cancelListening(call.arguments, result)
            "toggleLog" -> toggleLog(call.arguments)
            "cancelTest" -> cancelTasks(call.arguments, result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        activity = null
        applicationContext = null
        methodChannel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    private fun mapToCall(result: Result, arguments: Any?) {
        val argsMap = arguments as Map<*, *>

        val fileSize =
            if (argsMap.containsKey("fileSize")) argsMap["fileSize"] as Int else defaultFileSizeInBytes
        when (val args = argsMap["id"] as Int) {
            CallbacksEnum.START_DOWNLOAD_TESTING.ordinal -> startListening(args,
                result,
                "startDownloadTesting",
                argsMap["testServer"] as String,
                fileSize)
            CallbacksEnum.START_UPLOAD_TESTING.ordinal -> startListening(args,
                result,
                "startUploadTesting",
                argsMap["testServer"] as String,
                fileSize)
        }
    }

    private fun toggleLog(arguments: Any?) {
        val argsMap = arguments as Map<*, *>

        if (argsMap.containsKey("value")) {
            val logValue = argsMap["value"] as Boolean
            logger.enabled = logValue
        }
    }

    private val callbackById: MutableMap<Int, Runnable> = mutableMapOf()

    private fun startListening(
        args: Any,
        result: Result,
        methodName: String,
        testServer: String,
        fileSize: Int,
    ) {
        // Get callback id
        logger.print("test starting")
        val currentListenerId = args as Int
        val runnable = Runnable {
            if (callbackById.containsKey(currentListenerId)) {
                val argsMap: MutableMap<String, Any> = mutableMapOf()
                argsMap["id"] = currentListenerId
                logger.print("test listener Id: $currentListenerId")
                when (methodName) {
                    "startDownloadTesting" -> {
                        testDownloadSpeed(object : TestListener {
                            override fun onComplete(transferRate: Double) {
                                argsMap["transferRate"] = transferRate
                                argsMap["type"] = ListenerEnum.COMPLETE.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }

                            override fun onError(speedTestError: String, errorMessage: String) {
                                argsMap["speedTestError"] = speedTestError
                                argsMap["errorMessage"] = errorMessage
                                argsMap["type"] = ListenerEnum.ERROR.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }

                            override fun onProgress(percent: Double, transferRate: Double) {
                                logger.print("onProgress $percent, $transferRate")
                                argsMap["percent"] = percent
                                argsMap["transferRate"] = transferRate
                                argsMap["type"] = ListenerEnum.PROGRESS.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }
                        }, testServer, fileSize)
                    }
                    "startUploadTesting" -> {
                        testUploadSpeed(object : TestListener {
                            override fun onComplete(transferRate: Double) {
                                argsMap["transferRate"] = transferRate
                                argsMap["type"] = ListenerEnum.COMPLETE.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }

                            override fun onError(speedTestError: String, errorMessage: String) {
                                argsMap["speedTestError"] = speedTestError
                                argsMap["errorMessage"] = errorMessage
                                argsMap["type"] = ListenerEnum.ERROR.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }

                            override fun onProgress(percent: Double, transferRate: Double) {
                                argsMap["percent"] = percent
                                argsMap["transferRate"] = transferRate
                                argsMap["type"] = ListenerEnum.PROGRESS.ordinal
                                activity!!.runOnUiThread {
                                    methodChannel.invokeMethod("callListener", argsMap)
                                }
                            }
                        }, testServer, fileSize)
                    }
                }
                // Send some value to callback

            }
        }
        val thread = Thread(runnable)
        callbackById[currentListenerId] = runnable
        thread.start()
        // Return immediately
        result.success(null)
    }

    private fun testUploadSpeed(testListener: TestListener, testServer: String, fileSize: Int) {
        // add a listener to wait for speedtest completion and progress
        logger.print("Testing Testing")
        speedTestSocket.addSpeedTestListener(object : ISpeedTestListener {
            override fun onCompletion(report: SpeedTestReport) {
//                // called when download/upload is complete
//                logger.print("[COMPLETED] rate in octet/s : " + report.transferRateOctet)
//                logger.print("[COMPLETED] rate in bit/s   : " + report.transferRateBit)
//                testListener.onComplete(report.transferRateBit.toDouble())
            }

            override fun onError(speedTestError: SpeedTestError, errorMessage: String) {
                // called when a download/upload error occur
                logger.print("OnError: ${speedTestError.name}, $errorMessage")
                testListener.onError(errorMessage, speedTestError.name)
            }

            override fun onProgress(percent: Float, report: SpeedTestReport) {
//                // called to notify download/upload progress
//                logger.print("[PROGRESS] progress : $percent%")
//                logger.print("[PROGRESS] rate in octet/s : " + report.transferRateOctet)
//                logger.print("[PROGRESS] rate in bit/s   : " + report.transferRateBit)
//                testListener.onProgress(percent.toDouble(), report.transferRateBit.toDouble())
            }
        })
//        speedTestSocket.startFixedUpload(testServer, 10000000, 20000, 100)
        speedTestSocket.startUploadRepeat(testServer,
            defaultTestTimeoutInMillis,
            defaultResponseDelayInMillis,
            fileSize,
            object : IRepeatListener {
                override fun onCompletion(report: SpeedTestReport) {
                    // called when download/upload is complete
                    logger.print("[COMPLETED] rate in octet/s : " + report.transferRateOctet)
                    logger.print("[COMPLETED] rate in bit/s   : " + report.transferRateBit)
                    testListener.onComplete(report.transferRateBit.toDouble())
                }

                override fun onReport(report: SpeedTestReport) {
                    // called to notify download/upload progress
                    logger.print("[PROGRESS] progress : ${report.progressPercent}%")
                    logger.print("[PROGRESS] rate in octet/s : " + report.transferRateOctet)
                    logger.print("[PROGRESS] rate in bit/s   : " + report.transferRateBit)
                    testListener.onProgress(report.progressPercent.toDouble(),
                        report.transferRateBit.toDouble())
                }
            })
        logger.print("After Testing")
    }

    private fun testDownloadSpeed(testListener: TestListener, testServer: String, fileSize: Int) {
        // add a listener to wait for speedtest completion and progress
        logger.print("Testing Testing")
        speedTestSocket.addSpeedTestListener(object : ISpeedTestListener {
            override fun onCompletion(report: SpeedTestReport) {
//                // called when download/upload is complete
//                logger.print("[COMPLETED] rate in octet/s : " + report.transferRateOctet)
//                logger.print("[COMPLETED] rate in bit/s   : " + report.transferRateBit)
//                testListener.onComplete(report.transferRateBit.toDouble())
            }

            override fun onError(speedTestError: SpeedTestError, errorMessage: String) {
                // called when a download/upload error occur
                logger.print("OnError: ${speedTestError.name}, $errorMessage")
                testListener.onError(errorMessage, speedTestError.name)
            }

            override fun onProgress(percent: Float, report: SpeedTestReport) {
//                // called to notify download/upload progress
//                logger.print("[PROGRESS] progress : $percent%")
//                logger.print("[PROGRESS] rate in octet/s : " + report.transferRateOctet)
//                logger.print("[PROGRESS] rate in bit/s   : " + report.transferRateBit)
//                testListener.onProgress(percent.toDouble(), report.transferRateBit.toDouble())
            }
        })
//        speedTestSocket.startFixedDownload(testServer, 20000, 100)

        speedTestSocket.startDownloadRepeat(testServer,
            defaultTestTimeoutInMillis,
            defaultResponseDelayInMillis,
            object : IRepeatListener {
                override fun onCompletion(report: SpeedTestReport) {
                    // called when download/upload is complete
                    logger.print("[COMPLETED] rate in octet/s : " + report.transferRateOctet)
                    logger.print("[COMPLETED] rate in bit/s   : " + report.transferRateBit)
                    testListener.onComplete(report.transferRateBit.toDouble())
                }

                override fun onReport(report: SpeedTestReport) {
                    // called to notify download/upload progress
                    logger.print("[PROGRESS] progress : ${report.progressPercent}%")
                    logger.print("[PROGRESS] rate in octet/s : " + report.transferRateOctet)
                    logger.print("[PROGRESS] rate in bit/s   : " + report.transferRateBit)
                    testListener.onProgress(report.progressPercent.toDouble(),
                        report.transferRateBit.toDouble())
                }
            })

        logger.print("After Testing")
    }

    private fun cancelListening(args: Any, result: Result) {
        // Get callback id
        val currentListenerId = args as Int
        // Remove callback
        callbackById.remove(currentListenerId)
        // Do additional stuff if required to cancel the listener
        result.success(null)
    }

    private fun cancelTasks(arguments: Any?, result: Result) {
        Thread(Runnable {
            arguments?.let { args ->
                val argsMap = args as Map<*, *>
                try {
                    if (speedTestSocket.speedTestMode != SpeedTestMode.NONE) {
                        speedTestSocket.forceStopTask()
                        result.success(true)

                        if (argsMap.containsKey("id1")) {
                            val id1 = argsMap["id1"] as Int
                            val map: MutableMap<String, Any> = mutableMapOf()
                            map["id"] = id1
                            map["type"] = ListenerEnum.CANCEL.ordinal
                            activity!!.runOnUiThread {
                                methodChannel.invokeMethod("callListener", map)
                            }
                        }
                        if (argsMap.containsKey("id2")) {
                            val id2 = argsMap["id2"] as Int
                            val map: MutableMap<String, Any> = mutableMapOf()
                            map["id"] = id2
                            map["type"] = ListenerEnum.CANCEL.ordinal
                            activity!!.runOnUiThread {
                                methodChannel.invokeMethod("callListener", map)
                            }
                        }

                        speedTestSocket.clearListeners()
                        speedTestSocket = SpeedTestSocket()
                        return@Runnable
                    }
                } catch (e: Exception) {
                    e.localizedMessage?.let { logger.print(it) }
                }
                result.success(false)
            } ?: kotlin.run {
                result.success(false)
            }
        }).start()
    }
}

