import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
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
    // Ask for permissions before requesting data
    await [
      Permission.locationWhenInUse,
      Permission.phone,
      Permission.sms,
    ].request();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (Platform.isAndroid) androidInfo = await CarrierInfo.getAndroidInfo();
      if (Platform.isIOS) iosInfo = await CarrierInfo.getIosInfo();
    } catch (e) {
      print(e.toString());
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'CARRIER INFORMATION',
            style: TextStyle(
              fontSize: 15,
              color: CupertinoColors.systemGrey,
            ),
          ),
        ),
        HomeItem(
          title: 'supportsEmbeddedSIM',
          value: '${iosInfo?.supportsEmbeddedSIM}',
          isFirst: true,
        ),
        ...(iosInfo?.carrierRadioAccessTechnologyTypeList ?? []).map(
          (it) => HomeItem(
            title: '',
            value: it,
          ),
        ),
        ...(iosInfo?.carrierData ?? []).map(
          (it) => Column(
            children: [
              const SizedBox(height: 15),
              Text(
                'SIM: ${it.carrierName}',
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                ),
              ),
              const SizedBox(height: 15),
              ...it.toMap().entries.map(
                    (e) => HomeItem(
                      title: e.key,
                      value: '${e.value}',
                    ),
                  )
            ],
          ),
        ),
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
            Padding(
              padding: const EdgeInsets.all(15),
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
              value: '${androidInfo?.isVoiceCapable}',
              isFirst: true,
            ),
            HomeItem(
              title: 'isSmsCapable',
              value: '${androidInfo?.isSmsCapable}',
            ),
            HomeItem(
              title: 'isMultiSimSupported',
              value: '${androidInfo?.isMultiSimSupported}',
            ),
            HomeItem(
              title: 'isDataCapable',
              value: '${androidInfo?.isDataCapable}',
            ),
            HomeItem(
              title: 'isDataEnabled',
              value: '${androidInfo?.isDataEnabled}',
            ),
            ...(androidInfo?.telephonyInfo ?? []).map((it) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      'SIM: ${it.phoneNumber} (from telephonyInfo)',
                      style: TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...(it.toMap()).entries.map(
                          (val) => HomeItem(
                            title: '${val.key}',
                            value: '${val.value}',
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
                    style: TextStyle(
                      fontSize: 15,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...(it.toMap()).entries.map(
                        (val) => HomeItem(
                          title: '${val.key}',
                          value: '${val.value}',
                        ),
                      )
                ],
              );
            }),
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
  const HomeItem({
    super.key,
    required this.title,
    this.value,
    this.isFirst = false,
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
                  Text(title),
                  Spacer(),
                  Flexible(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Text(value ?? ''),
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

String jsonPretty(dynamic _obj) {
  String prettyprint;

  var obj = _obj;

  try {
    if (_obj is String) {
      obj = json.decode(_obj);
    }

    if (obj is Map ||
        obj is Map<dynamic, dynamic> ||
        obj is Map<String, dynamic>) {
      const encoder = JsonEncoder.withIndent('  ');
      prettyprint = encoder.convert(obj);
    } else {
      prettyprint = '$obj';
    }
  } catch (e) {
    return _obj;
  }

  return prettyprint;
}
