import 'package:carrier_info_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the example app title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Carrier Info example app'), findsOneWidget);
  });
}
