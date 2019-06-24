import 'package:flutter_test/flutter_test.dart';
import 'package:formgen_example/main.dart';

void main() {
  testWidgets('display all fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(App());

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Firstname'), findsOneWidget);
    expect(find.text('Lastname'), findsOneWidget);
  });
}
