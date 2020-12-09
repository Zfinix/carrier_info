import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'model/carrier_data.dart';

class CarrierInfo {
  static const MethodChannel _channel =
      const MethodChannel('plugins.chizi.tech/carrier_info');

  static Future<bool> get allowsVOIP async =>
      Platform.isAndroid ? true : await _channel.invokeMethod('allowsVOIP');

  static Future<String> get carrierName async =>
      await _channel.invokeMethod('carrierName');

  static Future<String> get isoCountryCode async {
    return await _channel.invokeMethod('isoCountryCode');
  }

  static Future<String> get mobileCountryCode async {
    return await _channel.invokeMethod('mobileCountryCode');
  }

  static Future<String> get mobileNetworkCode async =>
      await _channel.invokeMethod('mobileNetworkCode');

  static Future<String> get mobileNetworkOperator async =>
      await _channel.invokeMethod('mobileNetworkOperator');

  static Future<String> get radioType async =>
      await _channel.invokeMethod('radioType');

  static Future<String> get networkGeneration async =>
      await _channel.invokeMethod('networkGeneration');

  static Future<CarrierData> get all async => CarrierData(
        allowsVOIP: await allowsVOIP,
        carrierName: await carrierName,
        isoCountryCode: await isoCountryCode,
        mobileCountryCode: await mobileCountryCode,
        mobileNetworkCode: await mobileNetworkCode,
        mobileNetworkOperator: await mobileNetworkOperator,
        networkGeneration: await networkGeneration,
        radioType: await radioType,
      );
}
