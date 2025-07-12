import 'dart:async';
import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  IosCarrierData? _iosInfo;
  IosCarrierData? get iosInfo => _iosInfo;
  set iosInfo(IosCarrierData? iosInfo) {
    setState(() => _iosInfo = iosInfo);
  }

  AndroidCarrierData? _androidInfo;
  AndroidCarrierData? get androidInfo => _androidInfo;
  set androidInfo(AndroidCarrierData? carrierInfo) {
    setState(() => _androidInfo = carrierInfo);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (Platform.isAndroid) androidInfo = await CarrierInfo.getAndroidInfo();
      if (Platform.isIOS) iosInfo = await CarrierInfo.getIosInfo();
    } catch (e) {
      print('Error getting carrier info: $e');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Carrier Info example app'),
            border: Border.symmetric(
              horizontal: BorderSide(
                width: 0.5,
                color: CupertinoColors.systemGrey2.withOpacity(0.4),
              ),
            ),
          ),
          backgroundColor: CupertinoColors.lightBackgroundGray,
          child: Platform.isAndroid
              ? AndroidUI(androidInfo: androidInfo)
              : IosUI(iosInfo: iosInfo),
        ),
      ),
    );
  }
}

class IosUI extends StatelessWidget {
  const IosUI({
    super.key,
    this.iosInfo,
  });

  final IosCarrierData? iosInfo;

  String formatIOSVersion(Map<String, dynamic>? versionDict) {
    if (versionDict == null) return 'Unknown';

    final major = versionDict['majorVersion'] ?? 0;
    final minor = versionDict['minorVersion'] ?? 0;
    final patch = versionDict['patchVersion'] ?? 0;

    return '$major.$minor.$patch';
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're on iOS 16.0+ and show deprecation notice
    final versionInfo =
        iosInfo?.toMap()['_ios_version_info'] as Map<String, dynamic>?;
    final isDeprecated = versionInfo?['ctcarrier_deprecated'] as bool? ?? false;

    return ListView(
      children: [
        const SizedBox(height: 20),

        // Show deprecation notice if on iOS 16.0+
        if (isDeprecated) ...[
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: CupertinoColors.systemYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CupertinoColors.systemYellow.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: CupertinoColors.systemYellow,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'iOS 16.0+ Limitation',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemYellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  versionInfo?['deprecation_notice'] as String? ??
                      'CTCarrier is deprecated. Most carrier information is unavailable.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Device Status Section
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'DEVICE STATUS',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),

        HomeItem(
          title: 'SIM Inserted',
          value: '${iosInfo?.isSIMInserted ?? false}',
          isFirst: true,
        ),

        // iOS Version Info
        if (versionInfo != null) ...[
          HomeItem(
            title: 'iOS Version',
            value: formatIOSVersion(
                versionInfo['ios_version'] as Map<String, dynamic>?),
          ),
          HomeItem(
            title: 'CTCarrier Deprecated',
            value: '${versionInfo['ctcarrier_deprecated'] ?? false}',
          ),
        ],

        // Network Status Section
        if (iosInfo?.networkStatus != null) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'NETWORK STATUS',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          HomeItem(
            title: 'Has Cellular Data',
            value: '${iosInfo?.networkStatus?.hasCellularData ?? false}',
            isFirst: true,
          ),
          HomeItem(
            title: 'Active Services',
            value: '${iosInfo?.networkStatus?.activeServices ?? 0}',
          ),
          HomeItem(
            title: 'Technologies',
            value: (iosInfo?.networkStatus?.technologies?.isNotEmpty ?? false)
                ? iosInfo!.networkStatus!.technologies!.join(', ')
                : 'None',
          ),
        ],

        // Subscriber Information Section
        if (iosInfo?.subscriberInfo != null) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'SUBSCRIBER INFORMATION',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          HomeItem(
            title: 'Subscriber Count',
            value: '${iosInfo?.subscriberInfo?.subscriberCount ?? 0}',
            isFirst: true,
          ),
          HomeItem(
            title: 'Subscriber IDs',
            value: (iosInfo?.subscriberInfo?.subscriberIdentifiers.isNotEmpty ??
                    false)
                ? iosInfo!.subscriberInfo!.subscriberIdentifiers.join(', ')
                : 'None',
          ),
          if (iosInfo?.subscriberInfo?.carrierTokens != null)
            HomeItem(
              title: 'Carrier Tokens',
              value:
                  '${iosInfo?.subscriberInfo?.carrierTokens?.length ?? 0} tokens available',
            ),
        ],

        // Cellular Plan Information Section
        if (iosInfo?.cellularPlanInfo != null) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'CELLULAR PLAN INFORMATION',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          HomeItem(
            title: 'Supports Embedded SIM',
            value: '${iosInfo?.cellularPlanInfo?.supportsEmbeddedSIM ?? false}',
            isFirst: true,
          ),
        ],

        // Legacy supportsEmbeddedSIM (for backward compatibility)
        if (iosInfo?.cellularPlanInfo == null && iosInfo != null) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'LEGACY CARRIER INFORMATION',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          HomeItem(
            title: 'supportsEmbeddedSIM (Legacy)',
            value: '${iosInfo?.supportsEmbeddedSIM ?? false}',
            isFirst: true,
          ),
        ],

        // Radio Access Technology (still works on iOS 16.0+)
        if ((iosInfo?.carrierRadioAccessTechnologyTypeList ?? [])
            .isNotEmpty) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'RADIO ACCESS TECHNOLOGY (Available on all iOS versions)',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          ...(iosInfo?.carrierRadioAccessTechnologyTypeList ?? [])
              .asMap()
              .entries
              .map(
                (entry) => HomeItem(
                  title: 'Technology ${entry.key + 1}',
                  value: entry.value,
                  isFirst: entry.key == 0,
                ),
              ),
        ],

        // Carrier Data (limited on iOS 16.0+)
        if ((iosInfo?.carrierData ?? []).isNotEmpty) ...[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'CARRIER DATA',
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ),
          ...(iosInfo?.carrierData ?? []).asMap().entries.map(
            (entry) {
              final index = entry.key;
              final carrierData = entry.value;
              final carrierMap = carrierData.toMap();

              return Column(
                children: [
                  if (index > 0) const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Text(
                          'SIM ${index + 1}: ${carrierData.carrierName ?? 'Unknown'}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        if (isDeprecated) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            CupertinoIcons.exclamationmark_triangle_fill,
                            color: CupertinoColors.systemYellow,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ),
                  ...carrierMap.entries.map(
                    (e) {
                      // Skip internal fields
                      if (e.key.startsWith('_')) return const SizedBox.shrink();

                      // Highlight deprecated fields
                      final isDeprecatedField = isDeprecated &&
                          [
                            'carrierName',
                            'mobileCountryCode',
                            'mobileNetworkCode',
                            'isoCountryCode',
                            'carrierAllowsVOIP'
                          ].contains(e.key);

                      return HomeItem(
                        title: e.key,
                        value: e.value?.toString() ?? 'null',
                        isDeprecated: isDeprecatedField,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],

        // Show a message if no data is available
        if (iosInfo == null) ...[
          const SizedBox(height: 50),
          const Center(
            child: Column(
              children: [
                Icon(
                  CupertinoIcons.info_circle,
                  size: 50,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(height: 16),
                Text(
                  'Loading carrier information...',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }
}

class AndroidUI extends StatelessWidget {
  const AndroidUI({
    super.key,
    this.androidInfo,
  });

  final AndroidCarrierData? androidInfo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'CARRIER INFORMATION',
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            HomeItem(
              title: 'isVoiceCapable',
              value: '${androidInfo?.isVoiceCapable ?? false}',
              isFirst: true,
            ),
            HomeItem(
              title: 'isSmsCapable',
              value: '${androidInfo?.isSmsCapable ?? false}',
            ),
            HomeItem(
              title: 'isMultiSimSupported',
              value: androidInfo?.isMultiSimSupported ?? 'Unknown',
            ),
            HomeItem(
              title: 'isDataCapable',
              value: '${androidInfo?.isDataCapable ?? false}',
            ),
            HomeItem(
              title: 'isDataEnabled',
              value: '${androidInfo?.isDataEnabled ?? false}',
            ),
            ...(androidInfo?.telephonyInfo ?? []).map((it) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      'SIM: ${it.phoneNumber} (from telephonyInfo)',
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...(it.toMap()).entries.map(
                          (val) => HomeItem(
                            title: '${val.key}',
                            value: '${val.value ?? 'N/A'}',
                          ),
                        )
                  ],
                ),
              );
            }),
            ...(androidInfo?.subscriptionsInfo ?? []).map((it) {
              return Column(
                children: [
                  Text(
                    'SIM: ${it.phoneNumber} (from subscriptionsInfo)',
                    style: const TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...(it.toMap()).entries.map(
                        (val) => HomeItem(
                          title: '${val.key}',
                          value: '${val.value ?? 'N/A'}',
                        ),
                      )
                ],
              );
            }),

            // Show a message if no data is available
            if (androidInfo == null) ...[
              const SizedBox(height: 50),
              const Center(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.info_circle,
                      size: 50,
                      color: CupertinoColors.systemGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading carrier information...',
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class HomeItem extends StatelessWidget {
  final bool isFirst;
  final String title;
  final String? value;
  final bool isDeprecated;

  const HomeItem({
    super.key,
    required this.title,
    this.value,
    this.isFirst = false,
    this.isDeprecated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            if (!isFirst)
              Container(height: 0.5, color: Colors.grey.withOpacity(0.3)),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color:
                              isDeprecated ? CupertinoColors.systemGrey : null,
                        ),
                      ),
                      if (isDeprecated) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: CupertinoColors.systemYellow,
                          size: 12,
                        ),
                      ],
                    ],
                  ),
                  const Spacer(),
                  Flexible(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Text(
                          value ?? 'N/A',
                          style: TextStyle(
                            color: isDeprecated
                                ? CupertinoColors.systemGrey
                                : null,
                            fontStyle: isDeprecated ? FontStyle.italic : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
