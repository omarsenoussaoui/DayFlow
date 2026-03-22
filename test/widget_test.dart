import 'package:flutter_test/flutter_test.dart';
import 'package:dayflow/app.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DayFlowApp());
    await tester.pumpAndSettle();

    expect(find.text('DAILY TASKS'), findsOneWidget);
    expect(find.text('REMINDERS'), findsOneWidget);
    expect(find.text('QUICK TASKS'), findsOneWidget);
  });
}
