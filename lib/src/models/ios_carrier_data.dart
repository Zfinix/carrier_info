import 'dart:convert';

import 'package:flutter/foundation.dart';

class IosCarrierData {
  final List<CarrierData> carrierData;
  final bool supportsEmbeddedSIM;
  final List<String> carrierRadioAccessTechnologyTypeList;
  final bool isSIMInserted;
  final SubscriberInfo? subscriberInfo;
  final CellularPlanInfo? cellularPlanInfo;
  final NetworkStatus? networkStatus;

  IosCarrierData({
    required this.carrierData,
    required this.supportsEmbeddedSIM,
    required this.carrierRadioAccessTechnologyTypeList,
    required this.isSIMInserted,
    this.subscriberInfo,
    this.cellularPlanInfo,
    this.networkStatus,
  });

  IosCarrierData copyWith({
    List<CarrierData>? carrierData,
    bool? supportsEmbeddedSIM,
    List<String>? carrierRadioAccessTechnologyTypeList,
    bool? isSIMInserted,
    SubscriberInfo? subscriberInfo,
    CellularPlanInfo? cellularPlanInfo,
    NetworkStatus? networkStatus,
  }) {
    return IosCarrierData(
      carrierData: carrierData ?? this.carrierData,
      supportsEmbeddedSIM: supportsEmbeddedSIM ?? this.supportsEmbeddedSIM,
      carrierRadioAccessTechnologyTypeList:
          carrierRadioAccessTechnologyTypeList ??
              this.carrierRadioAccessTechnologyTypeList,
      isSIMInserted: isSIMInserted ?? this.isSIMInserted,
      subscriberInfo: subscriberInfo ?? this.subscriberInfo,
      cellularPlanInfo: cellularPlanInfo ?? this.cellularPlanInfo,
      networkStatus: networkStatus ?? this.networkStatus,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'carrierData': carrierData.map((x) => x.toMap()).toList(),
      'supportsEmbeddedSIM': supportsEmbeddedSIM,
      'carrierRadioAccessTechnologyTypeList':
          carrierRadioAccessTechnologyTypeList,
      'isSIMInserted': isSIMInserted,
      'subscriberInfo': subscriberInfo?.toMap(),
      'cellularPlanInfo': cellularPlanInfo?.toMap(),
      'networkStatus': networkStatus?.toMap(),
    };
  }

  factory IosCarrierData.fromMap(Map<dynamic, dynamic> map) {
    return IosCarrierData(
      carrierData: List<CarrierData>.from(
        map['carrierData']?.map(
              (x) => CarrierData.fromMap(x),
            ) ??
            [],
      ),
      supportsEmbeddedSIM: map['supportsEmbeddedSIM'] ?? false,
      carrierRadioAccessTechnologyTypeList:
          List<String>.from(map['carrierRadioAccessTechnologyTypeList'] ?? []),
      isSIMInserted: map['isSIMInserted'] ?? false,
      subscriberInfo: map['subscriberInfo'] != null
          ? SubscriberInfo.fromMap(map['subscriberInfo'])
          : null,
      cellularPlanInfo: map['cellularPlanInfo'] != null
          ? CellularPlanInfo.fromMap(map['cellularPlanInfo'])
          : null,
      networkStatus: map['networkStatus'] != null
          ? NetworkStatus.fromMap(map['networkStatus'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IosCarrierData.fromJson(String source) =>
      IosCarrierData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IosCarrierData(carrierData: $carrierData, supportsEmbeddedSIM: $supportsEmbeddedSIM, carrierRadioAccessTechnologyTypeList: $carrierRadioAccessTechnologyTypeList, isSIMInserted: $isSIMInserted, subscriberInfo: $subscriberInfo, cellularPlanInfo: $cellularPlanInfo, networkStatus: $networkStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IosCarrierData &&
        listEquals(other.carrierData, carrierData) &&
        other.supportsEmbeddedSIM == supportsEmbeddedSIM &&
        listEquals(other.carrierRadioAccessTechnologyTypeList,
            carrierRadioAccessTechnologyTypeList) &&
        other.isSIMInserted == isSIMInserted &&
        other.subscriberInfo == subscriberInfo &&
        other.cellularPlanInfo == cellularPlanInfo &&
        other.networkStatus == networkStatus;
  }

  @override
  int get hashCode {
    return carrierData.hashCode ^
        supportsEmbeddedSIM.hashCode ^
        carrierRadioAccessTechnologyTypeList.hashCode ^
        isSIMInserted.hashCode ^
        subscriberInfo.hashCode ^
        cellularPlanInfo.hashCode ^
        networkStatus.hashCode;
  }
}

class CarrierData {
  final String? mobileNetworkCode;
  final bool? carrierAllowsVOIP;
  final String? mobileCountryCode;
  final String? carrierName;
  final String? isoCountryCode;

  CarrierData({
    this.mobileNetworkCode,
    this.carrierAllowsVOIP,
    this.mobileCountryCode,
    this.carrierName,
    this.isoCountryCode,
  });

  CarrierData copyWith({
    String? mobileNetworkCode,
    bool? carrierAllowsVOIP,
    String? mobileCountryCode,
    String? carrierName,
    String? isoCountryCode,
  }) {
    return CarrierData(
      mobileNetworkCode: mobileNetworkCode ?? this.mobileNetworkCode,
      carrierAllowsVOIP: carrierAllowsVOIP ?? this.carrierAllowsVOIP,
      mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
      carrierName: carrierName ?? this.carrierName,
      isoCountryCode: isoCountryCode ?? this.isoCountryCode,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'mobileNetworkCode': mobileNetworkCode,
      'carrierAllowsVOIP': carrierAllowsVOIP,
      'mobileCountryCode': mobileCountryCode,
      'carrierName': carrierName,
      'isoCountryCode': isoCountryCode,
    };
  }

  factory CarrierData.fromMap(Map<dynamic, dynamic> map) {
    return CarrierData(
      mobileNetworkCode: map['mobileNetworkCode'],
      carrierAllowsVOIP: map['carrierAllowsVOIP'],
      mobileCountryCode: map['mobileCountryCode'],
      carrierName: map['carrierName'],
      isoCountryCode: map['isoCountryCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarrierData.fromJson(String source) =>
      CarrierData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CarrierData(mobileNetworkCode: $mobileNetworkCode, carrierAllowsVOIP: $carrierAllowsVOIP, mobileCountryCode: $mobileCountryCode, carrierName: $carrierName, isoCountryCode: $isoCountryCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarrierData &&
        other.mobileNetworkCode == mobileNetworkCode &&
        other.carrierAllowsVOIP == carrierAllowsVOIP &&
        other.mobileCountryCode == mobileCountryCode &&
        other.carrierName == carrierName &&
        other.isoCountryCode == isoCountryCode;
  }

  @override
  int get hashCode {
    return mobileNetworkCode.hashCode ^
        carrierAllowsVOIP.hashCode ^
        mobileCountryCode.hashCode ^
        carrierName.hashCode ^
        isoCountryCode.hashCode;
  }
}

class SubscriberInfo {
  final int subscriberCount;
  final List<String> subscriberIdentifiers;
  final List<String>? carrierTokens;

  SubscriberInfo({
    required this.subscriberCount,
    required this.subscriberIdentifiers,
    this.carrierTokens,
  });

  SubscriberInfo copyWith({
    int? subscriberCount,
    List<String>? subscriberIdentifiers,
    List<String>? carrierTokens,
  }) {
    return SubscriberInfo(
      subscriberCount: subscriberCount ?? this.subscriberCount,
      subscriberIdentifiers:
          subscriberIdentifiers ?? this.subscriberIdentifiers,
      carrierTokens: carrierTokens ?? this.carrierTokens,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'subscriberCount': subscriberCount,
      'subscriberIdentifiers': subscriberIdentifiers,
      'carrierTokens': carrierTokens,
    };
  }

  factory SubscriberInfo.fromMap(Map<dynamic, dynamic> map) {
    return SubscriberInfo(
      subscriberCount: map['subscriberCount'] ?? 0,
      subscriberIdentifiers:
          List<String>.from(map['subscriberIdentifiers'] ?? []),
      carrierTokens: map['carrierTokens'] != null
          ? List<String>.from(map['carrierTokens'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriberInfo.fromJson(String source) =>
      SubscriberInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubscriberInfo(subscriberCount: $subscriberCount, subscriberIdentifiers: $subscriberIdentifiers, carrierTokens: $carrierTokens)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriberInfo &&
        other.subscriberCount == subscriberCount &&
        listEquals(other.subscriberIdentifiers, subscriberIdentifiers) &&
        listEquals(other.carrierTokens, carrierTokens);
  }

  @override
  int get hashCode {
    return subscriberCount.hashCode ^
        subscriberIdentifiers.hashCode ^
        carrierTokens.hashCode;
  }
}

class CellularPlanInfo {
  final bool supportsEmbeddedSIM;

  CellularPlanInfo({
    required this.supportsEmbeddedSIM,
  });

  CellularPlanInfo copyWith({
    bool? supportsEmbeddedSIM,
  }) {
    return CellularPlanInfo(
      supportsEmbeddedSIM: supportsEmbeddedSIM ?? this.supportsEmbeddedSIM,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'supportsEmbeddedSIM': supportsEmbeddedSIM,
    };
  }

  factory CellularPlanInfo.fromMap(Map<dynamic, dynamic> map) {
    return CellularPlanInfo(
      supportsEmbeddedSIM: map['supportsEmbeddedSIM'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CellularPlanInfo.fromJson(String source) =>
      CellularPlanInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CellularPlanInfo(supportsEmbeddedSIM: $supportsEmbeddedSIM)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CellularPlanInfo &&
        other.supportsEmbeddedSIM == supportsEmbeddedSIM;
  }

  @override
  int get hashCode {
    return supportsEmbeddedSIM.hashCode;
  }
}

class NetworkStatus {
  final bool hasCellularData;
  final int? activeServices;
  final List<String>? technologies;

  NetworkStatus({
    required this.hasCellularData,
    this.activeServices,
    this.technologies,
  });

  NetworkStatus copyWith({
    bool? hasCellularData,
    int? activeServices,
    List<String>? technologies,
  }) {
    return NetworkStatus(
      hasCellularData: hasCellularData ?? this.hasCellularData,
      activeServices: activeServices ?? this.activeServices,
      technologies: technologies ?? this.technologies,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'hasCellularData': hasCellularData,
      'activeServices': activeServices,
      'technologies': technologies,
    };
  }

  factory NetworkStatus.fromMap(Map<dynamic, dynamic> map) {
    return NetworkStatus(
      hasCellularData: map['hasCellularData'] ?? false,
      activeServices: map['activeServices'],
      technologies: map['technologies'] != null
          ? List<String>.from(map['technologies'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NetworkStatus.fromJson(String source) =>
      NetworkStatus.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NetworkStatus(hasCellularData: $hasCellularData, activeServices: $activeServices, technologies: $technologies)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetworkStatus &&
        other.hasCellularData == hasCellularData &&
        other.activeServices == activeServices &&
        listEquals(other.technologies, technologies);
  }

  @override
  int get hashCode {
    return hasCellularData.hashCode ^
        activeServices.hashCode ^
        technologies.hashCode;
  }
}
