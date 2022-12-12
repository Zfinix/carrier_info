# 📱 Carrier Info

[![pub package](https://img.shields.io/pub/v/carrier_info.svg?label=carrier_info&color=blue)](https://pub.dev/packages/carrier_info)

Carrier Info gets networkType, networkGeneration, mobileCountryCode, mobileCountryCode, e.t.c from both android and ios devices. It's a port from this [js project](https://github.com/react-native-webrtc/react-native-carrier-info) and an improvement on the existing [flt_telephony_info package](https://pub.dev/packages/flt_telephony_info).

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/Zfinix/carrier_info/blob/main/1.png?raw=true" width="200">
<img src="https://github.com/Zfinix/carrier_info/blob/main/1.jpeg?raw=true" width="200">
</p>

### Fetching android carrier info

Docs: https://developer.android.com/reference/android/telephony/TelephonyManager#getNetworkCountryIso(), https://developer.android.com/reference/android/telephony/SubscriptionManager

```dart
 AndroidCarrierData? carrierInfo = await CarrierInfo.getAndroidInfo();
 returns  {
   "isVoiceCapable": true,
   "isDataEnabled": true,
   "subscriptionsInfo": [
     {
       "mobileCountryCode": "310",
       "isOpportunistic": false,
       "mobileNetworkCode": "260",
       "displayName": "T-Mobile",
       "isNetworkRoaming": false,
       "simSlotIndex": 0,
       "phoneNumber": "+15551234567",
       "countryIso": "us",
       "subscriptionType": 0,
       "cardId": 0,
       "isEmbedded": false,
       "carrierId": 1,
       "subscriptionId": 1,
       "simSerialNo": "",
       "dataRoaming": 0
     }
   ],
   "isDataCapable": true,
   "isMultiSimSupported": "MULTISIM_NOT_SUPPORTED_BY_HARDWARE",
   "isSmsCapable": true,
   "telephonyInfo": [
     {
       "networkCountryIso": "us",
       "mobileCountryCode": "310",
       "mobileNetworkCode": "260",
       "displayName": "T-Mobile",
       "simState": "SIM_STATE_READY",
       "isoCountryCode": "us",
       "cellId": {
         "cid": 47108,
         "lac": 8514
       },
       "phoneNumber": "+15551234567",
       "carrierName": "T-Mobile",
       "subscriptionId": 1,
       "networkGeneration": "4G",
       "radioType": "LTE",
       "networkOperatorName": "T-Mobile"
     }
   ]
 };
  

 IosCarrierData? carrierInfo = await CarrierInfo.getIosInfo();

 returns  {
   "carrierData": [
     {
       "mobileNetworkCode": null,
       "carrierAllowsVOIP": true,
       "mobileCountryCode": null,
       "carrierName": "glo",
       "isoCountryCode": null
     },
     {
        "mobileNetworkCode": "20",
        "isoCountryCode": "ng",
        "carrierAllowsVOIP": true,
        "carrierName": "Airtel",
        "mobileCountryCode": "621"
      }
    ],
    "supportsEmbeddedSIM": false,
    "carrierRadioAccessTechnologyTypeList": [
      "LTE"
    ]
  }
 };
```

## ✨ Contribution

Lots of PR's would be needed to make this plugin standard, as for iOS there's a permanent limitation for getting the exact data usage, there's only one way around it and it's super complex.
