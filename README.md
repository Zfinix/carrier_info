# 📱 Carrier Info

[![pub package](https://img.shields.io/pub/v/carrier_info.svg?label=carrier_info&color=blue)](https://pub.dev/packages/carrier_info)

> **⚠️ IMPORTANT iOS 16.0+ NOTICE**: Apple has deprecated `CTCarrier` starting with iOS 16.0. This means that most carrier-specific information (carrier name, country codes, network codes, etc.) will return `nil` or generic values on iOS 16.0 and later versions. This is an Apple platform limitation, not a plugin issue. See the [iOS Limitations](#ios-limitations) section for more details.

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
```

### Fetching iOS carrier info

```dart
 IosCarrierData? carrierInfo = await CarrierInfo.getIosInfo();

 // iOS 15.x and earlier - Full carrier information available
 returns  {
   "carrierData": [
     {
       "mobileNetworkCode": "20",
       "carrierAllowsVOIP": true,
       "mobileCountryCode": "621",
       "carrierName": "Airtel",
       "isoCountryCode": "ng"
     }
   ],
   "supportsEmbeddedSIM": false,
   "carrierRadioAccessTechnologyTypeList": ["LTE"],
   "isSIMInserted": true,
   "subscriberInfo": {
     "subscriberCount": 1,
     "subscriberIdentifiers": ["subscriber_id_here"],
     "carrierTokens": ["token_here"]
   },
   "cellularPlanInfo": {
     "supportsEmbeddedSIM": false
   },
   "networkStatus": {
     "hasCellularData": true,
     "activeServices": 1,
     "technologies": ["LTE"]
   },
   "_ios_version_info": {
     "ios_version": {...},
     "ctcarrier_deprecated": false,
     "deprecation_notice": "CTCarrier functionality is available on this iOS version."
   }
 }

 // iOS 16.0+ - Limited carrier information due to CTCarrier deprecation
 returns  {
   "carrierData": [
     {
       "mobileNetworkCode": null,
       "carrierAllowsVOIP": null,
       "mobileCountryCode": null,
       "carrierName": null,
       "isoCountryCode": null,
       "_deprecated_notice": "CTCarrier is deprecated in iOS 16.0+. Carrier information is no longer available."
     }
   ],
   "supportsEmbeddedSIM": false,
   "carrierRadioAccessTechnologyTypeList": ["LTE"],
   "isSIMInserted": true,
   "subscriberInfo": {
     "subscriberCount": 1,
     "subscriberIdentifiers": ["subscriber_id_here"],
     "carrierTokens": ["token_here"]
   },
   "cellularPlanInfo": {
     "supportsEmbeddedSIM": true
   },
   "networkStatus": {
     "hasCellularData": true,
     "activeServices": 1,
     "technologies": ["LTE"]
   },
   "_ios_version_info": {
     "ios_version": {...},
     "ctcarrier_deprecated": true,
     "deprecation_notice": "CTCarrier and CTSubscriber are deprecated in iOS 16.0+. Most carrier-specific information is no longer available for privacy and security reasons."
   }
 }
```

## iOS Features

### Available on All iOS Versions

#### SIM Detection
- **isSIMInserted**: Boolean indicating if a SIM card is inserted and active
- **networkStatus**: Real-time network connectivity information
- **carrierRadioAccessTechnologyTypeList**: Current radio technology (2G, 3G, 4G, 5G)

#### Network Status
```dart
"networkStatus": {
  "hasCellularData": true,        // Cellular data available
  "activeServices": 1,            // Number of active cellular services
  "technologies": ["LTE"]         // Current radio access technologies
}
```

#### Subscriber Information (iOS 16.0+)
```dart
"subscriberInfo": {
  "subscriberCount": 1,                           // Number of subscribers (dual SIM)
  "subscriberIdentifiers": ["subscriber_id"],     // Subscriber identifiers
  "carrierTokens": ["token"]                      // Carrier authentication tokens
}
```

#### Cellular Plan Information
```dart
"cellularPlanInfo": {
  "supportsEmbeddedSIM": true     // eSIM support detection
}
```

### iOS Version Detection

Use the `_ios_version_info` field to detect capabilities:

```dart
final iosInfo = await CarrierInfo.getIosInfo();
final versionInfo = iosInfo?.toMap()['_ios_version_info'] as Map<String, dynamic>?;
final isDeprecated = versionInfo?['ctcarrier_deprecated'] as bool? ?? false;

if (isDeprecated) {
  // Handle iOS 16.0+ limitations
  print('SIM Inserted: ${iosInfo?.isSIMInserted}');
  print('Network Status: ${iosInfo?.networkStatus?.hasCellularData}');
  print('Radio Tech: ${iosInfo?.carrierRadioAccessTechnologyTypeList}');
} else {
  // Full carrier information available
  print('Carrier: ${iosInfo?.carrierData?.first.carrierName}');
  print('MCC: ${iosInfo?.carrierData?.first.mobileCountryCode}');
}
```

## iOS Limitations

### CTCarrier Deprecation (iOS 16.0+)

Starting with iOS 16.0, Apple has deprecated the `CTCarrier` class and related APIs for privacy and security reasons. This affects the following information:

**❌ No longer available on iOS 16.0+:**
- Carrier name (`carrierName`)
- Mobile country code (`mobileCountryCode`)
- Mobile network code (`mobileNetworkCode`)
- ISO country code (`isoCountryCode`)
- VOIP allowance (`carrierAllowsVOIP`)

**✅ Still available on iOS 16.0+:**
- SIM insertion detection (`isSIMInserted`)
- Radio access technology types (`carrierRadioAccessTechnologyTypeList`)
- Network status (`networkStatus`)
- Subscriber information (`subscriberInfo`)
- Cellular plan information (`cellularPlanInfo`)

### Recommendations

1. **Check iOS version**: Use the `_ios_version_info` field to determine if you're running on iOS 16.0+ and handle the limitations accordingly.

2. **Use available features**: Focus on features that work across all iOS versions:
   ```dart
   // These work on all iOS versions
   final simInserted = iosInfo?.isSIMInserted ?? false;
   final hasData = iosInfo?.networkStatus?.hasCellularData ?? false;
   final radioTech = iosInfo?.carrierRadioAccessTechnologyTypeList ?? [];
   ```

3. **Graceful degradation**: Design your app to work without carrier-specific information on newer iOS versions.

4. **Alternative approaches**: Consider using network-based detection or user input for carrier information when needed.

5. **Android alternative**: For apps that require detailed carrier information, consider using the Android implementation which still provides full functionality.

### New iOS Models

The plugin now includes enhanced models for iOS data:

- **IosCarrierData**: Main container with all carrier information
- **CarrierData**: Individual carrier information (nullable fields for iOS 16.0+)
- **SubscriberInfo**: Subscriber and carrier token information
- **CellularPlanInfo**: Cellular plan provisioning information
- **NetworkStatus**: Real-time network connectivity status

### Technical References

- [Apple Developer Documentation - CTCarrier](https://developer.apple.com/documentation/coretelephony/ctcarrier)
- [Apple Developer Documentation - CTSubscriber](https://developer.apple.com/documentation/coretelephony/ctsubscriber)
- [Apple Developer Documentation - CTCellularPlanProvisioning](https://developer.apple.com/documentation/coretelephony/ctcellularplanprovisioning/)
- [Stack Overflow Discussion](https://stackoverflow.com/questions/76919011/ctcarrier-deprecation-issue-ios-16)
- [iOS 16.0 Release Notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-16-release-notes)

### Permissions
You should add permissions that are required to your android manifest:

```xml
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.READ_BASIC_PHONE_STATE" />
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.READ_PHONE_NUMBERS" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE" />
```

## ✨ Contribution

Lots of PR's would be needed to make this plugin standard, as for iOS there's a permanent limitation for getting the exact data usage, there's only one way around it and it's super complex.
