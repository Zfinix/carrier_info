import 'dart:async';

import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/services.dart';

class CarrierInfo {
  static const MethodChannel _channel =
      const MethodChannel('plugins.chizi.tech/carrier_info');

  /// Get carrier data from android device
  static Future<AndroidCarrierData?> getAndroidInfo() async {
    return AndroidCarrierData.fromMap(
      await _channel.invokeMethod('getAndroidInfo'),
    );
  }

  /// Get all carrier data ios device
  static Future<IosCarrierData> getIosInfo() async {
    return IosCarrierData.fromMap(
      await _channel.invokeMethod('getIosInfo'),
    );
  }
}
