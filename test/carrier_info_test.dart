import 'package:carrier_info/carrier_info.dart';
import 'package:carrier_info/src/messages.g.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _androidChannel =
    'dev.flutter.pigeon.carrier_info.AndroidCarrierApi.getAndroidInfo';
const _iosChannel = 'dev.flutter.pigeon.carrier_info.IosCarrierApi.getIosInfo';

/// The payload the 3.x method channel sent, used to prove the Pigeon path builds the same models.
final _legacyAndroidMap = {
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

final _androidMessage = AndroidCarrierMessage(
  isVoiceCapable: true,
  isDataEnabled: true,
  isDataCapable: true,
  isMultiSimSupported: 'MULTISIM_NOT_SUPPORTED_BY_HARDWARE',
  isSmsCapable: true,
  subscriptionsInfo: [
    AndroidSubscriptionMessage(
      mobileCountryCode: '310',
      isOpportunistic: false,
      mobileNetworkCode: '260',
      displayName: 'T-Mobile',
      isNetworkRoaming: false,
      simSlotIndex: 0,
      phoneNumber: '+15551234567',
      countryIso: 'us',
      subscriptionType: 0,
      cardId: 0,
      isEmbedded: false,
      carrierId: 1,
      subscriptionId: 1,
      simSerialNo: '8901260000000000000',
      dataRoaming: 0,
    ),
  ],
  telephonyInfo: [
    AndroidTelephonyMessage(
      networkCountryIso: 'us',
      mobileCountryCode: '310',
      mobileNetworkCode: '260',
      displayName: 'T-Mobile',
      simState: 'SIM_STATE_READY',
      isoCountryCode: 'us',
      cellId: CellIdMessage(cid: 47108, lac: 8514),
      phoneNumber: '+15551234567',
      carrierName: 'T-Mobile',
      subscriptionId: 1,
      networkGeneration: '4G',
      radioType: 'LTE',
      networkOperatorName: 'T-Mobile',
    ),
  ],
);

final _legacyIosMap = {
  'carrierData': [
    {
      'mobileNetworkCode': '10',
      'carrierAllowsVOIP': true,
      'mobileCountryCode': '234',
      'carrierName': 'O2',
      'isoCountryCode': 'gb',
    },
  ],
  'carrierRadioAccessTechnologyTypeList': ['LTE'],
  'isSIMInserted': true,
  'supportsEmbeddedSIM': true,
  'subscriberInfo': {
    'subscriberCount': 1,
    'subscriberIdentifiers': ['A'],
    'carrierTokens': null,
  },
  'cellularPlanInfo': {'supportsEmbeddedSIM': true},
  'networkStatus': {
    'hasCellularData': true,
    'activeServices': 1,
    'technologies': ['CTRadioAccessTechnologyLTE'],
  },
};

final _iosMessage = IosCarrierMessage(
  carrierData: [
    IosCarrierEntryMessage(
      mobileNetworkCode: '10',
      carrierAllowsVOIP: true,
      mobileCountryCode: '234',
      carrierName: 'O2',
      isoCountryCode: 'gb',
    ),
  ],
  carrierRadioAccessTechnologyTypeList: ['LTE'],
  isSIMInserted: true,
  supportsEmbeddedSIM: true,
  subscriberInfo: IosSubscriberMessage(
    subscriberCount: 1,
    subscriberIdentifiers: ['A'],
  ),
  networkStatus: IosNetworkStatusMessage(
    hasCellularData: true,
    activeServices: 1,
    technologies: ['CTRadioAccessTechnologyLTE'],
  ),
);

void _reply(String channel, List<Object?> envelope) {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final basic = BasicMessageChannel<Object?>(
    channel,
    AndroidCarrierApi.pigeonChannelCodec,
  );
  messenger.setMockDecodedMessageHandler<Object?>(basic, (_) async => envelope);
  addTearDown(() => messenger.setMockDecodedMessageHandler<Object?>(basic, null));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Android', () {
    test('builds the same model the 3.x channel did', () async {
      _reply(_androidChannel, [_androidMessage]);

      expect(
        await CarrierInfo.getAndroidInfo(),
        AndroidCarrierData.fromMap(_legacyAndroidMap),
      );
    });

    test('an empty reply falls back to the same defaults as before', () async {
      _reply(_androidChannel, [AndroidCarrierMessage()]);

      expect(await CarrierInfo.getAndroidInfo(), AndroidCarrierData.fromMap({}));
    });

    test('passes the 4.0 fields through', () async {
      _reply(_androidChannel, [
        AndroidCarrierMessage(
          activeDataSubscriptionId: 2,
          isEsimEnabled: true,
          subscriptionsInfo: [AndroidSubscriptionMessage(portIndex: 1)],
          telephonyInfo: [
            AndroidTelephonyMessage(
              simSlotIndex: 1,
              networkOperator: '23410',
              isNetworkRoaming: true,
              simCarrierId: 1911,
              simCarrierIdName: 'O2',
              signalLevel: 3,
              signalDbm: -95,
              displayNetworkType: 'NR_NSA',
              isUsingNonTerrestrialNetwork: false,
            ),
          ],
        ),
      ]);

      final info = (await CarrierInfo.getAndroidInfo())!;

      expect(info.activeDataSubscriptionId, 2);
      expect(info.isEsimEnabled, isTrue);
      expect(info.subscriptionsInfo.single.portIndex, 1);
      expect(
        info.telephonyInfo.single,
        TelephonyInfo.fromMap({
          'simSlotIndex': 1,
          'networkOperator': '23410',
          'isNetworkRoaming': true,
          'simCarrierId': 1911,
          'simCarrierIdName': 'O2',
          'signalLevel': 3,
          'signalDbm': -95,
          'displayNetworkType': 'NR_NSA',
          'isUsingNonTerrestrialNetwork': false,
        }),
      );
    });

    test('a native failure surfaces as a PlatformException', () async {
      _reply(_androidChannel, [
        'no_telephony',
        'This device has no telephony service.',
        null,
      ]);

      await expectLater(
        CarrierInfo.getAndroidInfo(),
        throwsA(isA<PlatformException>()
            .having((e) => e.code, 'code', 'no_telephony')),
      );
    });
  });

  group('iOS', () {
    test('builds the same model the 3.x channel did', () async {
      _reply(_iosChannel, [_iosMessage]);

      expect(await CarrierInfo.getIosInfo(), IosCarrierData.fromMap(_legacyIosMap));
    });

    test('an empty reply falls back to the same defaults as before', () async {
      _reply(_iosChannel, [IosCarrierMessage()]);

      expect(
        await CarrierInfo.getIosInfo(),
        IosCarrierData.fromMap({
          'cellularPlanInfo': {'supportsEmbeddedSIM': null},
        }),
      );
    });

    test('passes the 4.0 fields through', () async {
      _reply(_iosChannel, [
        IosCarrierMessage(
          dataServiceIdentifier: '0000000100000001',
          cellularDataRestriction: 'notRestricted',
          networkStatus: IosNetworkStatusMessage(
            isExpensive: true,
            isConstrained: false,
            usesCellular: true,
          ),
        ),
      ]);

      final info = await CarrierInfo.getIosInfo();

      expect(info.dataServiceIdentifier, '0000000100000001');
      expect(info.cellularDataRestriction, 'notRestricted');
      expect(
        info.networkStatus,
        NetworkStatus(
          hasCellularData: false,
          isExpensive: true,
          isConstrained: false,
          usesCellular: true,
        ),
      );
    });
  });

  group('CarrierSummary', () {
    test('Android reports each inserted SIM and the data SIM network', () {
      final summary = CarrierSummary.fromAndroid(AndroidCarrierData.fromMap({
        'activeDataSubscriptionId': 2,
        'isEsimEnabled': true,
        'telephonyInfo': [
          {
            'simState': 'SIM_STATE_READY',
            'carrierName': 'T-Mobile',
            'mobileCountryCode': '310',
            'mobileNetworkCode': '260',
            'isoCountryCode': 'us',
            'subscriptionId': 1,
            'networkGeneration': '4G',
            'radioType': 'LTE',
          },
          {
            'simState': 'SIM_STATE_READY',
            'carrierName': 'vodafone',
            'simCarrierIdName': 'Vodafone UK',
            'mobileCountryCode': '234',
            'mobileNetworkCode': '15',
            'isoCountryCode': 'gb',
            'subscriptionId': 2,
            'networkGeneration': '5G',
            'radioType': 'LTE',
          },
          {'simState': 'SIM_STATE_ABSENT'},
        ],
      }));

      expect(
        summary,
        const CarrierSummary(
          sims: [
            SimCarrier(
              carrierName: 'T-Mobile',
              mobileCountryCode: '310',
              mobileNetworkCode: '260',
              isoCountryCode: 'us',
              isDataSim: false,
            ),
            SimCarrier(
              carrierName: 'Vodafone UK',
              mobileCountryCode: '234',
              mobileNetworkCode: '15',
              isoCountryCode: 'gb',
              isDataSim: true,
            ),
          ],
          isSimInserted: true,
          supportsEmbeddedSim: true,
          networkGeneration: '5G',
          radioType: 'LTE',
        ),
      );
    });

    test('Android with no SIM reports nothing inserted', () {
      expect(
        CarrierSummary.fromAndroid(AndroidCarrierData.fromMap({
          'telephonyInfo': [
            {'simState': 'SIM_STATE_ABSENT'},
          ],
        })),
        const CarrierSummary(
          sims: [],
          isSimInserted: false,
          supportsEmbeddedSim: false,
        ),
      );
    });

    test('iOS maps the radio technology to a generation', () {
      expect(
        CarrierSummary.fromIos(IosCarrierData.fromMap(_legacyIosMap)),
        const CarrierSummary(
          sims: [
            SimCarrier(
              carrierName: 'O2',
              mobileCountryCode: '234',
              mobileNetworkCode: '10',
              isoCountryCode: 'gb',
            ),
          ],
          isSimInserted: true,
          supportsEmbeddedSim: true,
          networkGeneration: '4G',
          radioType: 'LTE',
        ),
      );
    });

    test('iOS 16+ lists each SIM by subscriber and marks the data SIM', () {
      expect(
        CarrierSummary.fromIos(IosCarrierData.fromMap({
          'carrierData': [<String, Object?>{}],
          'carrierRadioAccessTechnologyTypeList': ['NRNSA', 'LTE'],
          'isSIMInserted': true,
          'subscriberInfo': {
            'subscriberCount': 2,
            'subscriberIdentifiers': ['0000000100000001', '0000000100000002'],
          },
          'dataServiceIdentifier': '0000000100000002',
        })),
        const CarrierSummary(
          sims: [
            SimCarrier(isDataSim: false),
            SimCarrier(isDataSim: true),
          ],
          isSimInserted: true,
          supportsEmbeddedSim: false,
          networkGeneration: '5G',
          radioType: 'NRNSA',
        ),
      );
    });
  });
}
