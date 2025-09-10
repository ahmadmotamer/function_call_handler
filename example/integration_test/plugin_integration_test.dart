import 'package:flutter_test/flutter_test.dart';
import 'package:function_call_handler_example/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    "SingleExecution Button skips duplicate, Cancel cancels, Force runs twice",
    (WidgetTester tester) async {
      await tester.pumpWidget(FunctionManagerDemoApp());

      // SingleExecution test
      final singleButton = find.text('Test SingleExecution');
      await tester.tap(singleButton);
      await tester.pumpAndSettle();
      // Wait for async result
      await tester.pump(const Duration(seconds: 3));

      expect(
        find.textContaining(
          'Error: Skipped: request with key \'single\' already running',
        ),
        findsOneWidget,
      );

      // CancelAll test
      final cancelButton = find.text('Test CancelAll');
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('Completed Cancel2'), findsOneWidget);

      // ForceCall test
      final forceButton = find.text('Test ForceCall');
      await tester.tap(forceButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      expect(find.textContaining('Completed Force1'), findsOneWidget);
      expect(find.textContaining('Completed Force2'), findsOneWidget);
    },
  );
}
