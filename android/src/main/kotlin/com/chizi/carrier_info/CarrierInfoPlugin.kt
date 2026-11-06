package com.chizi.carrier_info

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/** CarrierInfoPlugin */
class CarrierInfoPlugin: FlutterPlugin {
  private var channel: MethodChannel? = null
  private val channelID = "plugins.chizi.tech/carrier_info"
  private var handler: MethodCallHandlerImpl? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setupChannel(flutterPluginBinding)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannel()
  }

  private fun setupChannel(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelID)
    handler = MethodCallHandlerImpl(flutterPluginBinding.applicationContext)
    channel?.setMethodCallHandler(handler)
  }

  private fun teardownChannel() {
    channel?.setMethodCallHandler(null)
    channel = null
    handler = null
  }
}
