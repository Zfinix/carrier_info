import 'dart:io';

import 'package:carrier_info/carrier_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reads carrier info from the device', (tester) async {
    final report = StringBuffer();
    if (Platform.isIOS) {
      report.writeln('IOS_INFO ${(await CarrierInfo.getIosInfo()).toJson()}');
    }
    if (Platform.isAndroid) {
      report.writeln(
          'ANDROID_INFO ${(await CarrierInfo.getAndroidInfo())?.toJson()}');
    }

    final summary = await CarrierInfo.getSummary();
    report.writeln('SUMMARY $summary');

    debugPrint(report.toString());
    File('${Directory.systemTemp.path}/carrier_info_report.txt')
        .writeAsStringSync(report.toString());
    expect(summary.sims, isA<List<SimCarrier>>());
  });
}
