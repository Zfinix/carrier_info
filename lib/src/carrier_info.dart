import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carrier_info/src/model/carrier_data.dart';
import 'package:flutter/services.dart';

class CarrierInfo {
  static const MethodChannel _channel =
      const MethodChannel('plugins.chizi.tech/carrier_info');

  /// Indicates if the carrier allows VoIP calls to be made on its network.
  static Future<bool> get allowsVOIP async =>
      Platform.isAndroid ? true : await _channel.invokeMethod('allowsVOIP');

  /// The name of the user’s home cellular service provider.
  static Future<String?> get carrierName =>
      _channel.invokeMethod('carrierName');

  /// The ISO country code for the user’s cellular service provider.
  static Future<String?> get isoCountryCode =>
      _channel.invokeMethod('isoCountryCode');

  /// The mobile country code (MCC) for the user’s cellular service provider.
  static Future<String?> get mobileCountryCode =>
      _channel.invokeMethod('mobileCountryCode');

  /// The mobile network code (MNC) for the user’s cellular service provider.
  static Future<String?> get mobileNetworkCode =>
      _channel.invokeMethod('mobileNetworkCode');

  /// The mobile network operator code for the user’s cellular service provider.
  static Future<String?> get mobileNetworkOperator =>
      _channel.invokeMethod('mobileNetworkOperator');

  /// The mobile network radioType: 5G, 4G ... 2G
  static Future<String?> get radioType async =>
      await _channel.invokeMethod('radioType');

  /// The mobile network generation: LTE, HSDPA, e.t.c
  static Future<String?> get networkGeneration =>
      _channel.invokeMethod('networkGeneration');

  /// The current cell id (cid)
  static Future<int?> get cid async {
    if (!Platform.isAndroid) {
      return null;
    }
    var data = await _channel.invokeMethod('cellId');
    var hm = json.decode(data);
    return hm["cid"];
  }

  /// The current local area code
  static Future<int?> get lac async {
    if (!Platform.isAndroid) {
      return null;
    }
    var data = await _channel.invokeMethod('cellId');
    var hm = json.decode(data);
    return hm["lac"];
  }

  /// Get all carrier data from device
  static Future<CarrierData?> get all async => CarrierData(
        allowsVOIP: await allowsVOIP,
        carrierName: await carrierName,
        isoCountryCode: await isoCountryCode,
        mobileCountryCode: await mobileCountryCode,
        mobileNetworkCode: await mobileNetworkCode,
        mobileNetworkOperator: await mobileNetworkOperator,
        networkGeneration: await networkGeneration,
        radioType: await radioType,
        cid: await cid,
        lac: await lac,
      );
}
