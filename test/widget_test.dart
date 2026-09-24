import 'package:armory/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ARMORY app loads', (tester) async {
    await tester.pumpWidget(const ArmoryApp());

    expect(
      find.byType(ArmoryApp),
      findsOneWidget,
    );
  });
}