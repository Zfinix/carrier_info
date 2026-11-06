import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/src/main/kotlin/com/chizi/carrier_info/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.chizi.carrier_info'),
    swiftOut: 'ios/carrier_info/Sources/carrier_info/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'carrier_info',
  ),
)
class CellIdMessage {
  int? cid;
  int? lac;
}

class AndroidSubscriptionMessage {
  String? mobileCountryCode;
  bool? isOpportunistic;
  String? mobileNetworkCode;
  String? displayName;
  bool? isNetworkRoaming;
  int? simSlotIndex;
  String? phoneNumber;
  String? countryIso;
  int? subscriptionType;
  int? cardId;
  bool? isEmbedded;
  int? carrierId;
  int? subscriptionId;
  String? simSerialNo;
  int? dataRoaming;
  int? portIndex;
}

class AndroidTelephonyMessage {
  int? simSlotIndex;
  String? networkCountryIso;
  String? mobileCountryCode;
  String? mobileNetworkCode;
  String? displayName;
  String? simState;
  String? isoCountryCode;
  CellIdMessage? cellId;
  String? phoneNumber;
  String? carrierName;
  int? subscriptionId;
  String? networkGeneration;
  String? radioType;
  String? networkOperatorName;
  String? networkOperator;
  bool? isNetworkRoaming;
  int? simCarrierId;
  String? simCarrierIdName;
  int? signalLevel;
  int? signalDbm;
  String? displayNetworkType;
  bool? isUsingNonTerrestrialNetwork;
}

class AndroidCarrierMessage {
  bool? isVoiceCapable;
  bool? isDataEnabled;
  bool? isDataCapable;
  String? isMultiSimSupported;
  bool? isSmsCapable;
  List<AndroidSubscriptionMessage>? subscriptionsInfo;
  List<AndroidTelephonyMessage>? telephonyInfo;
  int? activeDataSubscriptionId;
  bool? isEsimEnabled;
}

class IosCarrierEntryMessage {
  String? mobileNetworkCode;
  bool? carrierAllowsVOIP;
  String? mobileCountryCode;
  String? carrierName;
  String? isoCountryCode;
}

class IosSubscriberMessage {
  int? subscriberCount;
  List<String>? subscriberIdentifiers;
  List<String>? carrierTokens;
}

class IosNetworkStatusMessage {
  bool? hasCellularData;
  int? activeServices;
  List<String>? technologies;
  bool? isExpensive;
  bool? isConstrained;
  bool? usesCellular;
}

class IosCarrierMessage {
  List<IosCarrierEntryMessage>? carrierData;
  List<String>? carrierRadioAccessTechnologyTypeList;
  bool? isSIMInserted;
  bool? supportsEmbeddedSIM;
  IosSubscriberMessage? subscriberInfo;
  IosNetworkStatusMessage? networkStatus;
  String? dataServiceIdentifier;
  String? cellularDataRestriction;
}

@HostApi()
abstract class AndroidCarrierApi {
  @async
  AndroidCarrierMessage getAndroidInfo();
}

@HostApi()
abstract class IosCarrierApi {
  @async
  IosCarrierMessage getIosInfo();
}
