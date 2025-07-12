import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final channel = MethodChannel('carrier_info');

  TestWidgetsFlutterBinding.ensureInitialized();
}
