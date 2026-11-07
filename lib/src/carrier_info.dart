import 'dart:async';
import 'dart:io';

import 'package:carrier_info/carrier_info.dart';

import 'messages.g.dart';

class CarrierInfo {
  static final AndroidCarrierApi _androidApi = AndroidCarrierApi();
  static final IosCarrierApi _iosApi = IosCarrierApi();

  /// Get carrier data from android device
  static Future<AndroidCarrierData?> getAndroidInfo() async {
    return AndroidCarrierData.fromMap(
      _androidMap(await _androidApi.getAndroidInfo()),
    );
  }

  /// Get all carrier data ios device
  static Future<IosCarrierData> getIosInfo() async {
    return IosCarrierData.fromMap(_iosMap(await _iosApi.getIosInfo()));
  }

  /// The carrier details both platforms report, so callers do not need to branch on the platform.
  static Future<CarrierSummary> getSummary() async {
    if (Platform.isAndroid) {
      return CarrierSummary.fromAndroid((await getAndroidInfo())!);
    }
    if (Platform.isIOS) {
      return CarrierSummary.fromIos(await getIosInfo());
    }
    throw UnsupportedError('carrier_info only supports Android and iOS.');
  }
}

Map<String, Object?> _androidMap(AndroidCarrierMessage message) => {
      'isVoiceCapable': message.isVoiceCapable,
      'isDataEnabled': message.isDataEnabled,
      'isDataCapable': message.isDataCapable,
      'isMultiSimSupported': message.isMultiSimSupported,
      'isSmsCapable': message.isSmsCapable,
      'activeDataSubscriptionId': message.activeDataSubscriptionId,
      'isEsimEnabled': message.isEsimEnabled,
      'subscriptionsInfo': message.subscriptionsInfo
          ?.map((s) => {
                'mobileCountryCode': s.mobileCountryCode,
                'isOpportunistic': s.isOpportunistic,
                'mobileNetworkCode': s.mobileNetworkCode,
                'displayName': s.displayName,
                'isNetworkRoaming': s.isNetworkRoaming,
                'simSlotIndex': s.simSlotIndex,
                'phoneNumber': s.phoneNumber,
                'countryIso': s.countryIso,
                'subscriptionType': s.subscriptionType,
                'cardId': s.cardId,
                'isEmbedded': s.isEmbedded,
                'carrierId': s.carrierId,
                'subscriptionId': s.subscriptionId,
                'simSerialNo': s.simSerialNo,
                'dataRoaming': s.dataRoaming,
                'portIndex': s.portIndex,
              })
          .toList(),
      'telephonyInfo': message.telephonyInfo
          ?.map((t) => {
                'simSlotIndex': t.simSlotIndex,
                'networkCountryIso': t.networkCountryIso,
                'mobileCountryCode': t.mobileCountryCode,
                'mobileNetworkCode': t.mobileNetworkCode,
                'displayName': t.displayName,
                'simState': t.simState,
                'isoCountryCode': t.isoCountryCode,
                'cellId': t.cellId == null
                    ? null
                    : {'cid': t.cellId!.cid, 'lac': t.cellId!.lac},
                'phoneNumber': t.phoneNumber,
                'carrierName': t.carrierName,
                'subscriptionId': t.subscriptionId,
                'networkGeneration': t.networkGeneration,
                'radioType': t.radioType,
                'networkOperatorName': t.networkOperatorName,
                'networkOperator': t.networkOperator,
                'isNetworkRoaming': t.isNetworkRoaming,
                'simCarrierId': t.simCarrierId,
                'simCarrierIdName': t.simCarrierIdName,
                'signalLevel': t.signalLevel,
                'signalDbm': t.signalDbm,
                'displayNetworkType': t.displayNetworkType,
                'isUsingNonTerrestrialNetwork': t.isUsingNonTerrestrialNetwork,
              })
          .toList(),
    };

Map<String, Object?> _iosMap(IosCarrierMessage message) => {
      'carrierData': message.carrierData
          ?.map((c) => {
                'mobileNetworkCode': c.mobileNetworkCode,
                'carrierAllowsVOIP': c.carrierAllowsVOIP,
                'mobileCountryCode': c.mobileCountryCode,
                'carrierName': c.carrierName,
                'isoCountryCode': c.isoCountryCode,
              })
          .toList(),
      'carrierRadioAccessTechnologyTypeList':
          message.carrierRadioAccessTechnologyTypeList,
      'isSIMInserted': message.isSIMInserted,
      'supportsEmbeddedSIM': message.supportsEmbeddedSIM,
      'subscriberInfo': message.subscriberInfo == null
          ? null
          : {
              'subscriberCount': message.subscriberInfo!.subscriberCount,
              'subscriberIdentifiers':
                  message.subscriberInfo!.subscriberIdentifiers,
              'carrierTokens': message.subscriberInfo!.carrierTokens,
            },
      'cellularPlanInfo': {'supportsEmbeddedSIM': message.supportsEmbeddedSIM},
      'networkStatus': message.networkStatus == null
          ? null
          : {
              'hasCellularData': message.networkStatus!.hasCellularData,
              'activeServices': message.networkStatus!.activeServices,
              'technologies': message.networkStatus!.technologies,
              'isExpensive': message.networkStatus!.isExpensive,
              'isConstrained': message.networkStatus!.isConstrained,
              'usesCellular': message.networkStatus!.usesCellular,
            },
      'dataServiceIdentifier': message.dataServiceIdentifier,
      'cellularDataRestriction': message.cellularDataRestriction,
    };
