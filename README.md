# 📱 Carrier Info

[![pub package](https://img.shields.io/pub/v/carrier_info.svg?label=carrier_info&color=blue)](https://pub.dev/packages/carrier_info)

Carrier Info gets networkType, networkGeneration, mobileCountryCode, mobileCountryCode, e.t.c from both android and ios devices. It's a port from this [js project](https://github.com/react-native-webrtc/react-native-carrier-info) and an improvement on the existing [flt_telephony_info package](https://pub.dev/packages/flt_telephony_info).

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/Zfinix/carrier_info/blob/main/1.png?raw=true" width="200">
</p>

### allowsVOIP (iOS only)

```dart
 bool carrierInfo = await CarrierInfo.allowsVOIP; // Indicates if the carrier allows VoIP calls to be made on its network.
```

- If you configure a device for a carrier and then remove the SIM card, this property retains the Boolean value indicating the carrier’s policy regarding VoIP.
- Always return `true` on Android.

### carrierName

```dart
 String carrierInfo = await CarrierInfo.carrierName;  // The name of the user’s home cellular service provider.
```

- This string is provided by the carrier and formatted for presentation to the user. The value does not change if the user is roaming; it always represents the provider with whom the user has an account.
- If you configure a device for a carrier and then remove the SIM card, this property retains the name of the carrier.
- The value for this property is 'nil' if the device was never configured for a carrier.

### isoCountryCode

```dart
String carrierInfo = await CarrierInfo.isoCountryCode;  // The ISO country code for the user’s cellular service provider.
```

- This property uses the ISO 3166-1 country code representation.
- The value for this property is 'nil' if any of the following apply:
  - The device is in Airplane mode.
  - There is no SIM card in the device.
  - The device is outside of cellular service range.

### mobileCountryCode

```dart
String carrierInfo = await CarrierInfo.mobileCountryCode;  //The mobile country code (MCC) for the user’s cellular service provider.
```

- MCCs are defined by ITU-T Recommendation E.212, “List of Mobile Country or Geographical Area Codes.”
- The value for this property is 'nil' if any of the following apply:
  - There is no SIM card in the device.
  - The device is outside of cellular service range.
- The value may be 'nil' on hardware prior to iPhone 4S when in Airplane mode.

### mobileNetworkCode

```dart
String carrierInfo = await CarrierInfo.mobileNetworkCode // The mobile network code (MNC) for the user’s cellular service provider.
```

- The value for this property is 'nil' if any of the following apply:
- There is no SIM card in the device.
- The device is outside of cellular service range.
- The value may be 'nil' on hardware prior to iPhone 4S when in Airplane mode.

### networkGeneration

```dart
String carrierInfo = await CarrierInfo.networkGeneration // 5G, 4G ... 2G
```

### radioType

```dart
String carrierInfo = await CarrierInfo.radioType // LTE, HSDPA, e.t.c
```

### cid (Android only)

```dart
int carrierInfo = await CarrierInfo.cid // Cell Id, only on android for now, returns null on iPhone
```

### lac (Android only)

```dart
int carrierInfo = await CarrierInfo.lac //  Local Area Code, only on android for now, returns null on iPhone
```

## ✨ Contribution

Lots of PR's would be needed to make this plugin standard, as for iOS there's a permanent limitation for getting the exact data usage, there's only one way around it and it's super complex.
