import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _channel = MethodChannel('plugins.chizi.tech/carrier_info');

final _androidMap = {
  'isVoiceCapable': true,
  'isDataEnabled': true,
  'subscriptionsInfo': [
    {
      'mobileCountryCode': '310',
      'isOpportunistic': false,
      'mobileNetworkCode': '260',
      'displayName': 'T-Mobile',
      'isNetworkRoaming': false,
      'simSlotIndex': 0,
      'phoneNumber': '+15551234567',
      'countryIso': 'us',
      'subscriptionType': 0,
      'cardId': 0,
      'isEmbedded': false,
      'carrierId': 1,
      'subscriptionId': 1,
      'simSerialNo': '8901260000000000000',
      'dataRoaming': 0,
    },
  ],
  'isDataCapable': true,
  'isMultiSimSupported': 'MULTISIM_NOT_SUPPORTED_BY_HARDWARE',
  'isSmsCapable': true,
  'telephonyInfo': [
    {
      'networkCountryIso': 'us',
      'mobileCountryCode': '310',
      'mobileNetworkCode': '260',
      'displayName': 'T-Mobile',
      'simState': 'SIM_STATE_READY',
      'isoCountryCode': 'us',
      'cellId': {'cid': 47108, 'lac': 8514},
      'phoneNumber': '+15551234567',
      'carrierName': 'T-Mobile',
      'subscriptionId': 1,
      'networkGeneration': '4G',
      'radioType': 'LTE',
      'networkOperatorName': 'T-Mobile',
    },
  ],
};

void _mockChannel(
  Object? Function(MethodCall call) handler,
  List<MethodCall> calls,
) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async {
        calls.add(call);
        return handler(call);
      });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AndroidCarrierData.fromMap', () {
    test('parses subscriptions and telephony entries', () {
      final info = AndroidCarrierData.fromMap(_androidMap);

      expect(info.subscriptionsInfo.single.displayName, 'T-Mobile');
      expect(info.subscriptionsInfo.single.simSerialNo, '8901260000000000000');
      expect(info.telephonyInfo.single.cellId, CellId(cid: 47108, lac: 8514));
      expect(info.isMultiSimSupported, 'MULTISIM_NOT_SUPPORTED_BY_HARDWARE');
    });

    test('treats missing lists as empty', () {
      final info = AndroidCarrierData.fromMap({'isVoiceCapable': true});

      expect(info.subscriptionsInfo, isEmpty);
      expect(info.telephonyInfo, isEmpty);
      expect(info.isVoiceCapable, isTrue);
    });
  });

  group('IosCarrierData.fromMap', () {
    test('falls back to defaults for an empty map', () {
      expect(
        IosCarrierData.fromMap({}),
        equals(
          IosCarrierData(
            carrierData: const [],
            supportsEmbeddedSIM: false,
            carrierRadioAccessTechnologyTypeList: const [],
            isSIMInserted: false,
          ),
        ),
      );
    });
  });

  group('CarrierInfo channel', () {
    test(
      'getAndroidInfo calls the native method and parses the result',
      () async {
        final calls = <MethodCall>[];
        _mockChannel((_) => _androidMap, calls);

        final info = await CarrierInfo.getAndroidInfo();

        expect(calls.map((call) => call.method), ['getAndroidInfo']);
        expect(info, equals(AndroidCarrierData.fromMap(_androidMap)));
      },
    );

    test('getIosInfo calls the native method and parses the result', () async {
      final calls = <MethodCall>[];
      _mockChannel((_) => <String, dynamic>{}, calls);

      final info = await CarrierInfo.getIosInfo();

      expect(calls.map((call) => call.method), ['getIosInfo']);
      expect(info.isSIMInserted, isFalse);
    });
  });
}
