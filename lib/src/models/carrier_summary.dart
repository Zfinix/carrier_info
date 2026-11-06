import 'package:flutter/foundation.dart';

import 'android_carrier_data.dart';
import 'ios_carrier_data.dart';

/// One active SIM. Fields are null when the platform does not report them,
/// which is always the case for carrier details on iOS 16 and later.
class SimCarrier {
  final String? carrierName;
  final String? mobileCountryCode;
  final String? mobileNetworkCode;
  final String? isoCountryCode;

  /// Whether this SIM carries mobile data. Null when the platform cannot tell.
  final bool? isDataSim;

  const SimCarrier({
    this.carrierName,
    this.mobileCountryCode,
    this.mobileNetworkCode,
    this.isoCountryCode,
    this.isDataSim,
  });

  @override
  String toString() {
    return 'SimCarrier(carrierName: $carrierName, mobileCountryCode: $mobileCountryCode, mobileNetworkCode: $mobileNetworkCode, isoCountryCode: $isoCountryCode, isDataSim: $isDataSim)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimCarrier &&
        other.carrierName == carrierName &&
        other.mobileCountryCode == mobileCountryCode &&
        other.mobileNetworkCode == mobileNetworkCode &&
        other.isoCountryCode == isoCountryCode &&
        other.isDataSim == isDataSim;
  }

  @override
  int get hashCode {
    return carrierName.hashCode ^
        mobileCountryCode.hashCode ^
        mobileNetworkCode.hashCode ^
        isoCountryCode.hashCode ^
        isDataSim.hashCode;
  }
}

/// The carrier details both Android and iOS report, from [CarrierInfo.getSummary].
class CarrierSummary {
  final List<SimCarrier> sims;
  final bool isSimInserted;
  final bool supportsEmbeddedSim;

  /// The generation of the network carrying mobile data: 2G, 3G, 4G or 5G.
  final String? networkGeneration;

  /// The radio technology behind [networkGeneration], such as LTE or NR.
  final String? radioType;

  const CarrierSummary({
    required this.sims,
    required this.isSimInserted,
    required this.supportsEmbeddedSim,
    this.networkGeneration,
    this.radioType,
  });

  factory CarrierSummary.fromAndroid(AndroidCarrierData data) {
    final inserted = data.telephonyInfo
        .where((t) => t.simState.isNotEmpty && t.simState != 'SIM_STATE_ABSENT')
        .toList();
    final dataSim = inserted.where(
      (t) => t.subscriptionId == data.activeDataSubscriptionId,
    );
    final network = dataSim.isNotEmpty
        ? dataSim.first
        : (inserted.isNotEmpty ? inserted.first : null);

    return CarrierSummary(
      sims: [
        for (final t in inserted)
          SimCarrier(
            carrierName: _nonEmpty(t.simCarrierIdName) ?? _nonEmpty(t.carrierName),
            mobileCountryCode: _nonEmpty(t.mobileCountryCode),
            mobileNetworkCode: _nonEmpty(t.mobileNetworkCode),
            isoCountryCode: _nonEmpty(t.isoCountryCode),
            isDataSim: data.activeDataSubscriptionId == null
                ? null
                : t.subscriptionId == data.activeDataSubscriptionId,
          ),
      ],
      isSimInserted: inserted.isNotEmpty,
      supportsEmbeddedSim: data.isEsimEnabled ??
          data.subscriptionsInfo.any((s) => s.isEmbedded),
      networkGeneration: _nonEmpty(network?.networkGeneration),
      radioType: _nonEmpty(network?.radioType),
    );
  }

  factory CarrierSummary.fromIos(IosCarrierData data) {
    final technology = data.carrierRadioAccessTechnologyTypeList.isNotEmpty
        ? data.carrierRadioAccessTechnologyTypeList.first
        : null;

    final carriers = data.carrierData
        .where((c) =>
            c.carrierName != null ||
            c.mobileCountryCode != null ||
            c.mobileNetworkCode != null)
        .toList();
    final subscribers = data.subscriberInfo?.subscriberIdentifiers ?? const [];

    return CarrierSummary(
      sims: carriers.isNotEmpty
          ? [
              for (final c in carriers)
                SimCarrier(
                  carrierName: c.carrierName,
                  mobileCountryCode: c.mobileCountryCode,
                  mobileNetworkCode: c.mobileNetworkCode,
                  isoCountryCode: c.isoCountryCode,
                ),
            ]
          : [
              for (final id in subscribers)
                SimCarrier(
                  isDataSim: data.dataServiceIdentifier == null
                      ? null
                      : id == data.dataServiceIdentifier,
                ),
            ],
      isSimInserted: data.isSIMInserted,
      supportsEmbeddedSim: data.supportsEmbeddedSIM,
      networkGeneration: technology == null ? null : _iosGeneration(technology),
      radioType: technology,
    );
  }

  @override
  String toString() {
    return 'CarrierSummary(sims: $sims, isSimInserted: $isSimInserted, supportsEmbeddedSim: $supportsEmbeddedSim, networkGeneration: $networkGeneration, radioType: $radioType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarrierSummary &&
        listEquals(other.sims, sims) &&
        other.isSimInserted == isSimInserted &&
        other.supportsEmbeddedSim == supportsEmbeddedSim &&
        other.networkGeneration == networkGeneration &&
        other.radioType == radioType;
  }

  @override
  int get hashCode {
    return sims.hashCode ^
        isSimInserted.hashCode ^
        supportsEmbeddedSim.hashCode ^
        networkGeneration.hashCode ^
        radioType.hashCode;
  }
}

String? _nonEmpty(String? value) =>
    value == null || value.isEmpty ? null : value;

String? _iosGeneration(String technology) {
  switch (technology) {
    case 'GPRS':
    case 'Edge':
    case 'CDMA1x':
    case '2G':
      return '2G';
    case 'WCDMA':
    case 'HSDPA':
    case 'HSUPA':
    case 'CDMAEVDORev0':
    case 'CDMAEVDORevA':
    case 'CDMAEVDORevB':
    case 'eHRPD':
    case '3G':
      return '3G';
    case 'LTE':
    case '4G':
      return '4G';
    case 'NRNSA':
    case 'NR':
    case '5G':
      return '5G';
    default:
      return null;
  }
}
