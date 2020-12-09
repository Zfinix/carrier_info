//Carrier Data Model
class CarrierData {
  final bool allowsVOIP;
  final String carrierName;
  final String isoCountryCode;
  final String mobileCountryCode;
  final String mobileNetworkCode;
  final String mobileNetworkOperator;
  final String networkGeneration;
  final String radioType;

  CarrierData({
    this.allowsVOIP = false,
    this.carrierName,
    this.isoCountryCode,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.mobileNetworkOperator,
    this.networkGeneration,
    this.radioType,
  });

  @override
  String toString() {
    return '''${this.runtimeType}(
   allowsVOIP: ${this.allowsVOIP},
   carrierName: ${this.carrierName},
   isoCountryCode: ${this.isoCountryCode},
   mobileCountryCode: ${this.mobileCountryCode},
   mobileNetworkCode: ${this.mobileNetworkCode},
   mobileNetworkOperator: ${this.mobileNetworkOperator},
   networkGeneration: ${this.networkGeneration},
   radioType: ${this.radioType},
  })''';
  }
}
