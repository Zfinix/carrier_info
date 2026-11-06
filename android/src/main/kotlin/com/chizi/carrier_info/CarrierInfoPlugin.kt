package com.chizi.carrier_info

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** CarrierInfoPlugin */
class CarrierInfoPlugin : FlutterPlugin {
  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AndroidCarrierApi.setUp(binding.binaryMessenger, AndroidCarrierApiImpl(binding.applicationContext))
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AndroidCarrierApi.setUp(binding.binaryMessenger, null)
  }
}
