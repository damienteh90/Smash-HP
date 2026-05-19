import 'package:flutter_test/flutter_test.dart';
import 'package:smash_hp/main.dart';

void main() {
  testWidgets('opens Smash HP home screen', (tester) async {
    await tester.pumpWidget(const SmashHpApp());
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('Smash HP'), findsOneWidget);
    expect(find.text('Start Battle'), findsOneWidget);
  });
}
