import 'dart:convert';

import 'package:flutter/foundation.dart';

class IosCarrierData {
  final List<CarrierData> carrierData;
  final bool supportsEmbeddedSIM;
  final List<String> carrierRadioAccessTechnologyTypeList;
  IosCarrierData({
    required this.carrierData,
    required this.supportsEmbeddedSIM,
    required this.carrierRadioAccessTechnologyTypeList,
  });

  IosCarrierData copyWith({
    List<CarrierData>? carrierData,
    bool? supportsEmbeddedSIM,
    List<String>? carrierRadioAccessTechnologyTypeList,
  }) {
    return IosCarrierData(
      carrierData: carrierData ?? this.carrierData,
      supportsEmbeddedSIM: supportsEmbeddedSIM ?? this.supportsEmbeddedSIM,
      carrierRadioAccessTechnologyTypeList:
          carrierRadioAccessTechnologyTypeList ??
              this.carrierRadioAccessTechnologyTypeList,
    );
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'carrierData': carrierData.map((x) => x.toMap()).toList(),
      'supportsEmbeddedSIM': supportsEmbeddedSIM,
      'carrierRadioAccessTechnologyTypeList':
          carrierRadioAccessTechnologyTypeList,
    };
  }

  factory IosCarrierData.fromMap(Map<dynamic, dynamic> map) {
    return IosCarrierData(
      carrierData: List<CarrierData>.from(
          map['carrierData']?.map((x) => CarrierData.fromMap(x))),
      supportsEmbeddedSIM: map['supportsEmbeddedSIM'] ?? false,
      carrierRadioAccessTechnologyTypeList:
          List<String>.from(map['carrierRadioAccessTechnologyTypeList']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IosCarrierData.fromJson(String source) =>
      IosCarrierData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IosCarrierData(carrierData: $carrierData, supportsEmbeddedSIM: $supportsEmbeddedSIM, carrierRadioAccessTechnologyTypeList: $carrierRadioAccessTechnologyTypeList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IosCarrierData &&
        listEquals(other.carrierData, carrierData) &&
        other.supportsEmbeddedSIM == supportsEmbeddedSIM &&
        listEquals(other.carrierRadioAccessTechnologyTypeList,
            carrierRadioAccessTechnologyTypeList);
  }

  @override
  int get hashCode {
    return carrierData.hashCode ^
        supportsEmbeddedSIM.hashCode ^
        carrierRadioAccessTechnologyTypeList.hashCode;
  }
}

class CarrierData {
  final String mobileNetworkCode;
  final bool carrierAllowsVOIP;
  final String mobileCountryCode;
  final String carrierName;
  final String isoCountryCode;
  CarrierData({
    required this.mobileNetworkCode,
    required this.carrierAllowsVOIP,
    required this.mobileCountryCode,
    required this.carrierName,
    required this.isoCountryCode,
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
      mobileNetworkCode: map['mobileNetworkCode'] ?? '',
      carrierAllowsVOIP: map['carrierAllowsVOIP'] ?? false,
      mobileCountryCode: map['mobileCountryCode'] ?? '',
      carrierName: map['carrierName'] ?? '',
      isoCountryCode: map['isoCountryCode'] ?? '',
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
