import 'dart:convert';
import 'package:flutter/foundation.dart';

class AndroidCarrierData {
  final bool isVoiceCapable;
  final bool isDataEnabled;
  final List<SubscriptionsInfo> subscriptionsInfo;
  final bool isDataCapable;
  final String isMultiSimSupported;
  final bool isSmsCapable;
  final List<TelephonyInfo> telephonyInfo;
  final int? activeDataSubscriptionId;
  final bool? isEsimEnabled;
  AndroidCarrierData({
    required this.isVoiceCapable,
    required this.isDataEnabled,
    required this.subscriptionsInfo,
    required this.isDataCapable,
    required this.isMultiSimSupported,
    required this.isSmsCapable,
    required this.telephonyInfo,
    this.activeDataSubscriptionId,
    this.isEsimEnabled,
  });

  AndroidCarrierData copyWith({
    bool? isVoiceCapable,
    bool? isDataEnabled,
    List<SubscriptionsInfo>? subscriptionsInfo,
    bool? isDataCapable,
    String? isMultiSimSupported,
    bool? isSmsCapable,
    List<TelephonyInfo>? telephonyInfo,
    int? activeDataSubscriptionId,
    bool? isEsimEnabled,
  }) {
    return AndroidCarrierData(
      isVoiceCapable: isVoiceCapable ?? this.isVoiceCapable,
      isDataEnabled: isDataEnabled ?? this.isDataEnabled,
      subscriptionsInfo: subscriptionsInfo ?? this.subscriptionsInfo,
      isDataCapable: isDataCapable ?? this.isDataCapable,
      isMultiSimSupported: isMultiSimSupported ?? this.isMultiSimSupported,
      isSmsCapable: isSmsCapable ?? this.isSmsCapable,
      telephonyInfo: telephonyInfo ?? this.telephonyInfo,
      activeDataSubscriptionId: activeDataSubscriptionId ?? this.activeDataSubscriptionId,
      isEsimEnabled: isEsimEnabled ?? this.isEsimEnabled,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'isVoiceCapable': isVoiceCapable,
      'isDataEnabled': isDataEnabled,
      'subscriptionsInfo': subscriptionsInfo.map((x) => x.toMap()).toList(),
      'isDataCapable': isDataCapable,
      'isMultiSimSupported': isMultiSimSupported,
      'isSmsCapable': isSmsCapable,
      'telephonyInfo': telephonyInfo.map((x) => x.toMap()).toList(),
      'activeDataSubscriptionId': activeDataSubscriptionId,
      'isEsimEnabled': isEsimEnabled,
    };
  }

  factory AndroidCarrierData.fromMap(Map<dynamic, dynamic> map) {
    return AndroidCarrierData(
      isVoiceCapable: map['isVoiceCapable'] ?? false,
      isDataEnabled: map['isDataEnabled'] ?? false,
      subscriptionsInfo: List<SubscriptionsInfo>.from(
          (map['subscriptionsInfo'] ?? []).map((x) => SubscriptionsInfo.fromMap(x))),
      isDataCapable: map['isDataCapable'] ?? false,
      isMultiSimSupported: map['isMultiSimSupported'] ?? '',
      isSmsCapable: map['isSmsCapable'] ?? false,
      telephonyInfo: List<TelephonyInfo>.from(
          (map['telephonyInfo'] ?? []).map((x) => TelephonyInfo.fromMap(x))),
      activeDataSubscriptionId: map['activeDataSubscriptionId'],
      isEsimEnabled: map['isEsimEnabled'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AndroidCarrierData.fromJson(String source) =>
      AndroidCarrierData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AndroidCarrierData(isVoiceCapable: $isVoiceCapable, isDataEnabled: $isDataEnabled, subscriptionsInfo: $subscriptionsInfo, isDataCapable: $isDataCapable, isMultiSimSupported: $isMultiSimSupported, isSmsCapable: $isSmsCapable, telephonyInfo: $telephonyInfo, activeDataSubscriptionId: $activeDataSubscriptionId, isEsimEnabled: $isEsimEnabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AndroidCarrierData &&
        other.isVoiceCapable == isVoiceCapable &&
        other.isDataEnabled == isDataEnabled &&
        listEquals(other.subscriptionsInfo, subscriptionsInfo) &&
        other.isDataCapable == isDataCapable &&
        other.isMultiSimSupported == isMultiSimSupported &&
        other.isSmsCapable == isSmsCapable &&
        listEquals(other.telephonyInfo, telephonyInfo) &&
        other.activeDataSubscriptionId == activeDataSubscriptionId &&
        other.isEsimEnabled == isEsimEnabled;
  }

  @override
  int get hashCode {
    return isVoiceCapable.hashCode ^
        isDataEnabled.hashCode ^
        subscriptionsInfo.hashCode ^
        isDataCapable.hashCode ^
        isMultiSimSupported.hashCode ^
        isSmsCapable.hashCode ^
        telephonyInfo.hashCode ^
        activeDataSubscriptionId.hashCode ^
        isEsimEnabled.hashCode;
  }
}

class SubscriptionsInfo {
  /// The mobile country code (MCC) for the user’s cellular service provider.
  final String mobileCountryCode;
  final bool isOpportunistic;

  /// The mobile network code (MNC) for the user’s cellular service provider.
  final String mobileNetworkCode;

  /// The name of the user’s home cellular service provider.
  final String displayName;
  final bool isNetworkRoaming;
  final int simSlotIndex;
  final String phoneNumber;

  /// The ISO country code for the user’s cellular service provider.
  final String countryIso;
  final int subscriptionType;
  final int cardId;
  final bool isEmbedded;
  final int carrierId;
  final int subscriptionId;
  final String simSerialNo;
  final int dataRoaming;
  final int? portIndex;
  SubscriptionsInfo({
    required this.mobileCountryCode,
    required this.isOpportunistic,
    required this.mobileNetworkCode,
    required this.displayName,
    required this.isNetworkRoaming,
    required this.simSlotIndex,
    required this.phoneNumber,
    required this.countryIso,
    required this.subscriptionType,
    required this.cardId,
    required this.isEmbedded,
    required this.carrierId,
    required this.subscriptionId,
    required this.simSerialNo,
    required this.dataRoaming,
    this.portIndex,
  });

  SubscriptionsInfo copyWith({
    String? mobileCountryCode,
    bool? isOpportunistic,
    String? mobileNetworkCode,
    String? displayName,
    bool? isNetworkRoaming,
    int? simSlotIndex,
    String? phoneNumber,
    String? countryIso,
    int? subscriptionType,
    int? cardId,
    bool? isEmbedded,
    int? carrierId,
    int? subscriptionId,
    String? simSerialNo,
    int? dataRoaming,
    int? portIndex,
  }) {
    return SubscriptionsInfo(
      mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
      isOpportunistic: isOpportunistic ?? this.isOpportunistic,
      mobileNetworkCode: mobileNetworkCode ?? this.mobileNetworkCode,
      displayName: displayName ?? this.displayName,
      isNetworkRoaming: isNetworkRoaming ?? this.isNetworkRoaming,
      simSlotIndex: simSlotIndex ?? this.simSlotIndex,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryIso: countryIso ?? this.countryIso,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      cardId: cardId ?? this.cardId,
      isEmbedded: isEmbedded ?? this.isEmbedded,
      carrierId: carrierId ?? this.carrierId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      simSerialNo: simSerialNo ?? this.simSerialNo,
      dataRoaming: dataRoaming ?? this.dataRoaming,
      portIndex: portIndex ?? this.portIndex,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'mobileCountryCode': mobileCountryCode,
      'isOpportunistic': isOpportunistic,
      'mobileNetworkCode': mobileNetworkCode,
      'displayName': displayName,
      'isNetworkRoaming': isNetworkRoaming,
      'simSlotIndex': simSlotIndex,
      'phoneNumber': phoneNumber,
      'countryIso': countryIso,
      'subscriptionType': subscriptionType,
      'cardId': cardId,
      'isEmbedded': isEmbedded,
      'carrierId': carrierId,
      'subscriptionId': subscriptionId,
      'simSerialNo': simSerialNo,
      'dataRoaming': dataRoaming,
      'portIndex': portIndex,
    };
  }

  factory SubscriptionsInfo.fromMap(Map<dynamic, dynamic> map) {
    return SubscriptionsInfo(
      mobileCountryCode: map['mobileCountryCode'] ?? '',
      isOpportunistic: map['isOpportunistic'] ?? false,
      mobileNetworkCode: map['mobileNetworkCode'] ?? '',
      displayName: map['displayName'] ?? '',
      isNetworkRoaming: map['isNetworkRoaming'] ?? false,
      simSlotIndex: map['simSlotIndex'] ?? 0,
      phoneNumber: map['phoneNumber'] ?? '',
      countryIso: map['countryIso'] ?? '',
      subscriptionType: map['subscriptionType'] ?? 0,
      cardId: map['cardId'] ?? 0,
      isEmbedded: map['isEmbedded'] ?? false,
      carrierId: map['carrierId'] ?? 0,
      subscriptionId: map['subscriptionId'] ?? 0,
      simSerialNo: map['simSerialNo'] ?? '',
      dataRoaming: map['dataRoaming'] ?? 0,
      portIndex: map['portIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionsInfo.fromJson(String source) =>
      SubscriptionsInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubscriptionsInfo(mobileCountryCode: $mobileCountryCode, isOpportunistic: $isOpportunistic, mobileNetworkCode: $mobileNetworkCode, displayName: $displayName, isNetworkRoaming: $isNetworkRoaming, simSlotIndex: $simSlotIndex, phoneNumber: $phoneNumber, countryIso: $countryIso, subscriptionType: $subscriptionType, cardId: $cardId, isEmbedded: $isEmbedded, carrierId: $carrierId, subscriptionId: $subscriptionId, simSerialNo: $simSerialNo, dataRoaming: $dataRoaming, portIndex: $portIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionsInfo &&
        other.mobileCountryCode == mobileCountryCode &&
        other.isOpportunistic == isOpportunistic &&
        other.mobileNetworkCode == mobileNetworkCode &&
        other.displayName == displayName &&
        other.isNetworkRoaming == isNetworkRoaming &&
        other.simSlotIndex == simSlotIndex &&
        other.phoneNumber == phoneNumber &&
        other.countryIso == countryIso &&
        other.subscriptionType == subscriptionType &&
        other.cardId == cardId &&
        other.isEmbedded == isEmbedded &&
        other.carrierId == carrierId &&
        other.subscriptionId == subscriptionId &&
        other.simSerialNo == simSerialNo &&
        other.dataRoaming == dataRoaming &&
        other.portIndex == portIndex;
  }

  @override
  int get hashCode {
    return mobileCountryCode.hashCode ^
        isOpportunistic.hashCode ^
        mobileNetworkCode.hashCode ^
        displayName.hashCode ^
        isNetworkRoaming.hashCode ^
        simSlotIndex.hashCode ^
        phoneNumber.hashCode ^
        countryIso.hashCode ^
        subscriptionType.hashCode ^
        cardId.hashCode ^
        isEmbedded.hashCode ^
        carrierId.hashCode ^
        subscriptionId.hashCode ^
        simSerialNo.hashCode ^
        dataRoaming.hashCode ^
        portIndex.hashCode;
  }
}

class TelephonyInfo {
  final String networkCountryIso;
  final String mobileCountryCode;

  /// The mobile network code (MNC) for the user’s cellular service provider.
  final String mobileNetworkCode;

  /// The name of the user’s home cellular service provider.
  final String displayName;

  /// Constant indicating the state of the device SIM card in a logical slot; SIM_STATE_UNKNOWN, SIM_STATE_ABSENT, SIM_STATE_PIN_REQUIRED, SIM_STATE_PUK_REQUIRED, SIM_STATE_NETWORK_LOCKED, SIM_STATE_READY, SIM_STATE_NOT_READY, SIM_STATE_PERM_DISABLED, SIM_STATE_CARD_IO_ERROR, SIM_STATE_CARD_RESTRICTED,
  final String simState;

  /// The ISO country code for the user’s cellular service provider.
  final String isoCountryCode;

  /// The cell id (cid) and local area code
  final CellId? cellId;

  /// Phone number of the sim
  final String phoneNumber;

  /// Carrier name of the sim
  final String carrierName;

  final int subscriptionId;

  /// The mobile network radioType: 5G, 4G ... 2G
  final String networkGeneration;

  /// The mobile network generation: LTE, HSDPA, e.t.c
  final String? radioType;

  final String networkOperatorName;
  final int? simSlotIndex;
  final String? networkOperator;
  final bool? isNetworkRoaming;
  final int? simCarrierId;
  final String? simCarrierIdName;
  final int? signalLevel;
  final int? signalDbm;
  final String? displayNetworkType;
  final bool? isUsingNonTerrestrialNetwork;
  TelephonyInfo({
    required this.networkCountryIso,
    required this.mobileCountryCode,
    required this.mobileNetworkCode,
    required this.displayName,
    required this.simState,
    required this.isoCountryCode,
    this.cellId,
    required this.phoneNumber,
    required this.carrierName,
    required this.subscriptionId,
    required this.networkGeneration,
    this.radioType,
    required this.networkOperatorName,
    this.simSlotIndex,
    this.networkOperator,
    this.isNetworkRoaming,
    this.simCarrierId,
    this.simCarrierIdName,
    this.signalLevel,
    this.signalDbm,
    this.displayNetworkType,
    this.isUsingNonTerrestrialNetwork,
  });

  TelephonyInfo copyWith({
    String? networkCountryIso,
    String? mobileCountryCode,
    String? mobileNetworkCode,
    String? displayName,
    String? simState,
    String? isoCountryCode,
    CellId? cellId,
    String? phoneNumber,
    String? carrierName,
    int? subscriptionId,
    int? phoneCount,
    String? networkGeneration,
    String? radioType,
    String? networkOperatorName,
    int? simSlotIndex,
    String? networkOperator,
    bool? isNetworkRoaming,
    int? simCarrierId,
    String? simCarrierIdName,
    int? signalLevel,
    int? signalDbm,
    String? displayNetworkType,
    bool? isUsingNonTerrestrialNetwork,
  }) {
    return TelephonyInfo(
      networkCountryIso: networkCountryIso ?? this.networkCountryIso,
      mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
      mobileNetworkCode: mobileNetworkCode ?? this.mobileNetworkCode,
      displayName: displayName ?? this.displayName,
      simState: simState ?? this.simState,
      isoCountryCode: isoCountryCode ?? this.isoCountryCode,
      cellId: cellId ?? this.cellId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      carrierName: carrierName ?? this.carrierName,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      networkGeneration: networkGeneration ?? this.networkGeneration,
      radioType: radioType ?? this.radioType,
      networkOperatorName: networkOperatorName ?? this.networkOperatorName,
      simSlotIndex: simSlotIndex ?? this.simSlotIndex,
      networkOperator: networkOperator ?? this.networkOperator,
      isNetworkRoaming: isNetworkRoaming ?? this.isNetworkRoaming,
      simCarrierId: simCarrierId ?? this.simCarrierId,
      simCarrierIdName: simCarrierIdName ?? this.simCarrierIdName,
      signalLevel: signalLevel ?? this.signalLevel,
      signalDbm: signalDbm ?? this.signalDbm,
      displayNetworkType: displayNetworkType ?? this.displayNetworkType,
      isUsingNonTerrestrialNetwork: isUsingNonTerrestrialNetwork ?? this.isUsingNonTerrestrialNetwork,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'networkCountryIso': networkCountryIso,
      'mobileCountryCode': mobileCountryCode,
      'mobileNetworkCode': mobileNetworkCode,
      'displayName': displayName,
      'simState': simState,
      'isoCountryCode': isoCountryCode,
      'cellId': cellId?.toMap(),
      'phoneNumber': phoneNumber,
      'carrierName': carrierName,
      'subscriptionId': subscriptionId,
      'networkGeneration': networkGeneration,
      'radioType': radioType,
      'networkOperatorName': networkOperatorName,
      'simSlotIndex': simSlotIndex,
      'networkOperator': networkOperator,
      'isNetworkRoaming': isNetworkRoaming,
      'simCarrierId': simCarrierId,
      'simCarrierIdName': simCarrierIdName,
      'signalLevel': signalLevel,
      'signalDbm': signalDbm,
      'displayNetworkType': displayNetworkType,
      'isUsingNonTerrestrialNetwork': isUsingNonTerrestrialNetwork,
    };
  }

  factory TelephonyInfo.fromMap(Map<dynamic, dynamic> map) {
    return TelephonyInfo(
      networkCountryIso: map['networkCountryIso'] ?? '',
      mobileCountryCode: map['mobileCountryCode'] ?? '',
      mobileNetworkCode: map['mobileNetworkCode'] ?? '',
      displayName: map['displayName'] ?? '',
      simState: map['simState'] ?? '',
      isoCountryCode: map['isoCountryCode'] ?? '',
      cellId: map['cellId'] != null ? CellId.fromMap(map['cellId']) : null,
      phoneNumber: map['phoneNumber'] ?? '',
      carrierName: map['carrierName'] ?? '',
      subscriptionId: map['subscriptionId'] ?? 0,
      networkGeneration: map['networkGeneration'] ?? '',
      radioType: map['radioType'],
      networkOperatorName: map['networkOperatorName'] ?? '',
      simSlotIndex: map['simSlotIndex'],
      networkOperator: map['networkOperator'],
      isNetworkRoaming: map['isNetworkRoaming'],
      simCarrierId: map['simCarrierId'],
      simCarrierIdName: map['simCarrierIdName'],
      signalLevel: map['signalLevel'],
      signalDbm: map['signalDbm'],
      displayNetworkType: map['displayNetworkType'],
      isUsingNonTerrestrialNetwork: map['isUsingNonTerrestrialNetwork'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TelephonyInfo.fromJson(String source) =>
      TelephonyInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TelephonyInfo(networkCountryIso: $networkCountryIso, mobileCountryCode: $mobileCountryCode, mobileNetworkCode: $mobileNetworkCode, displayName: $displayName, simState: $simState, isoCountryCode: $isoCountryCode, cellId: $cellId, phoneNumber: $phoneNumber, carrierName: $carrierName, subscriptionId: $subscriptionId, networkGeneration: $networkGeneration, radioType: $radioType, networkOperatorName: $networkOperatorName, simSlotIndex: $simSlotIndex, networkOperator: $networkOperator, isNetworkRoaming: $isNetworkRoaming, simCarrierId: $simCarrierId, simCarrierIdName: $simCarrierIdName, signalLevel: $signalLevel, signalDbm: $signalDbm, displayNetworkType: $displayNetworkType, isUsingNonTerrestrialNetwork: $isUsingNonTerrestrialNetwork)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TelephonyInfo &&
        other.networkCountryIso == networkCountryIso &&
        other.mobileCountryCode == mobileCountryCode &&
        other.mobileNetworkCode == mobileNetworkCode &&
        other.displayName == displayName &&
        other.simState == simState &&
        other.isoCountryCode == isoCountryCode &&
        other.cellId == cellId &&
        other.phoneNumber == phoneNumber &&
        other.carrierName == carrierName &&
        other.subscriptionId == subscriptionId &&
        other.networkGeneration == networkGeneration &&
        other.radioType == radioType &&
        other.networkOperatorName == networkOperatorName &&
        other.simSlotIndex == simSlotIndex &&
        other.networkOperator == networkOperator &&
        other.isNetworkRoaming == isNetworkRoaming &&
        other.simCarrierId == simCarrierId &&
        other.simCarrierIdName == simCarrierIdName &&
        other.signalLevel == signalLevel &&
        other.signalDbm == signalDbm &&
        other.displayNetworkType == displayNetworkType &&
        other.isUsingNonTerrestrialNetwork == isUsingNonTerrestrialNetwork;
  }

  @override
  int get hashCode {
    return networkCountryIso.hashCode ^
        mobileCountryCode.hashCode ^
        mobileNetworkCode.hashCode ^
        displayName.hashCode ^
        simState.hashCode ^
        isoCountryCode.hashCode ^
        cellId.hashCode ^
        phoneNumber.hashCode ^
        carrierName.hashCode ^
        subscriptionId.hashCode ^
        networkGeneration.hashCode ^
        radioType.hashCode ^
        networkOperatorName.hashCode ^
        simSlotIndex.hashCode ^
        networkOperator.hashCode ^
        isNetworkRoaming.hashCode ^
        simCarrierId.hashCode ^
        simCarrierIdName.hashCode ^
        signalLevel.hashCode ^
        signalDbm.hashCode ^
        displayNetworkType.hashCode ^
        isUsingNonTerrestrialNetwork.hashCode;
  }
}

class CellId {
  final int cid;
  final int lac;
  CellId({
    required this.cid,
    required this.lac,
  });

  CellId copyWith({
    int? cid,
    int? lac,
  }) {
    return CellId(
      cid: cid ?? this.cid,
      lac: lac ?? this.lac,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'cid': cid,
      'lac': lac,
    };
  }

  factory CellId.fromMap(Map<dynamic, dynamic> map) {
    return CellId(
      cid: map['cid'] ?? 0,
      lac: map['lac'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CellId.fromJson(String source) => CellId.fromMap(json.decode(source));

  @override
  String toString() => 'CellId(cid: $cid, lac: $lac)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CellId && other.cid == cid && other.lac == lac;
  }

  @override
  int get hashCode => cid.hashCode ^ lac.hashCode;
}
