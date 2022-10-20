import 'dart:convert';

/// Carrier Data Model
class CarrierData {
  final bool allowsVOIP;
  final String? carrierName;
  final String? isoCountryCode;
  final String? mobileCountryCode;
  final String? mobileNetworkCode;
  final String? mobileNetworkOperator;
  final String? networkGeneration;
  final String? radioType;
  final int? cid;
  final int? lac;

  const CarrierData({
    this.allowsVOIP = false,
    this.carrierName,
    this.isoCountryCode,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.mobileNetworkOperator,
    this.networkGeneration,
    this.radioType,
    this.cid,
    this.lac,
  });

  @override
  String toString() {
    return 'CarrierData(allowsVOIP: $allowsVOIP, carrierName: $carrierName, isoCountryCode: $isoCountryCode, mobileCountryCode: $mobileCountryCode, mobileNetworkCode: $mobileNetworkCode, mobileNetworkOperator: $mobileNetworkOperator, networkGeneration: $networkGeneration, radioType: $radioType, cid: $cid, lac: $lac)';
  }

  CarrierData copyWith({
    bool? allowsVOIP,
    String? carrierName,
    String? isoCountryCode,
    String? mobileCountryCode,
    String? mobileNetworkCode,
    String? mobileNetworkOperator,
    String? networkGeneration,
    String? radioType,
    int? cid,
    int? lac,
  }) {
    return CarrierData(
      allowsVOIP: allowsVOIP ?? this.allowsVOIP,
      carrierName: carrierName ?? this.carrierName,
      isoCountryCode: isoCountryCode ?? this.isoCountryCode,
      mobileCountryCode: mobileCountryCode ?? this.mobileCountryCode,
      mobileNetworkCode: mobileNetworkCode ?? this.mobileNetworkCode,
      mobileNetworkOperator:
          mobileNetworkOperator ?? this.mobileNetworkOperator,
      networkGeneration: networkGeneration ?? this.networkGeneration,
      radioType: radioType ?? this.radioType,
      cid: cid ?? this.cid,
      lac: lac ?? this.lac,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allowsVOIP': allowsVOIP,
      'carrierName': carrierName,
      'isoCountryCode': isoCountryCode,
      'mobileCountryCode': mobileCountryCode,
      'mobileNetworkCode': mobileNetworkCode,
      'mobileNetworkOperator': mobileNetworkOperator,
      'networkGeneration': networkGeneration,
      'radioType': radioType,
      'cid': cid,
      'lac': lac
    };
  }

  factory CarrierData.fromMap(Map<String, dynamic> map) {
    return CarrierData(
      allowsVOIP: map['allowsVOIP'],
      carrierName: map['carrierName'],
      isoCountryCode: map['isoCountryCode'],
      mobileCountryCode: map['mobileCountryCode'],
      mobileNetworkCode: map['mobileNetworkCode'],
      mobileNetworkOperator: map['mobileNetworkOperator'],
      networkGeneration: map['networkGeneration'],
      radioType: map['radioType'],
      cid: map['cid'],
      lac: map['lac'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarrierData.fromJson(String source) =>
      CarrierData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarrierData && other.toJson() == toJson();
  }

  @override
  int get hashCode {
    return allowsVOIP.hashCode ^
        carrierName.hashCode ^
        isoCountryCode.hashCode ^
        mobileCountryCode.hashCode ^
        mobileNetworkCode.hashCode ^
        mobileNetworkOperator.hashCode ^
        networkGeneration.hashCode ^
        radioType.hashCode ^
        cid.hashCode ^
        lac.hashCode;
  }
}
