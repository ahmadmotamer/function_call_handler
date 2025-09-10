import 'package:flutter_test/flutter_test.dart';
import 'package:function_call_handler/function_call_handler.dart';
import 'package:function_call_handler/function_call_handler_method_channel.dart';
import 'package:mockito/mockito.dart';

// Mock your FunctionCallManager
class MockFunctionCallManager extends Mock implements FunctionCallManager {}

void main() {
  late FunctionCallHandlerMethodChannel handler;
  late MockFunctionCallManager mockManager;

  setUp(() {
    mockManager = MockFunctionCallManager();
    handler = FunctionCallHandlerMethodChannel();

    // Inject the mock into the private manager field using extension or reflection (if possible)
    handler._manager =
        mockManager; // If _manager is accessible, else use constructor or a setter
  });

  test('execute delegates call to FunctionCallManager', () async {
    final key = 'testKey';
    final type = RequestType.singleExecution;
    final expectedResult = 'result';

    // Stub the execute method on the mock manager
    when(
      mockManager.execute<String>(
        function: anyNamed('function'),
        key: key,
        type: type,
      ),
    ).thenAnswer((_) async => expectedResult);

    // Call the execute method on the handler
    final result = await handler.execute<String>(
      function: () async => 'ignored', // This will be overridden by mock
      key: key,
      type: type,
    );

    // Verify that the result matches mock return
    expect(result, expectedResult);

    // Verify the call to mockManager.execute
    verify(
      mockManager.execute<String>(
        function: anyNamed('function'),
        key: key,
        type: type,
      ),
    ).called(1);
  });
}
