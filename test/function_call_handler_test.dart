import 'package:flutter_test/flutter_test.dart';
import 'package:function_call_handler/function_call_handler.dart';
import 'package:function_call_handler/function_call_handler_platform_interface.dart';
import 'package:mockito/mockito.dart';

// Mocking the platform interface
class MockFunctionCallHandlerPlatform extends Mock
    implements FunctionCallHandlerPlatform {}

void main() {
  late MockFunctionCallHandlerPlatform mockPlatform;

  setUp(() {
    mockPlatform = MockFunctionCallHandlerPlatform();
    FunctionCallHandlerPlatform.instance = mockPlatform;
  });

  test('execute calls platform instance execute method', () async {
    final key = 'testKey';
    final type = RequestType.singleExecution;
    final expectedResult = 'some result';

    // Arrange mock to return expected result regardless of input function
    when(
      mockPlatform.execute<String>(
        function: anyNamed('function'),
        key: key,
        type: type,
      ),
    ).thenAnswer((_) async => expectedResult);

    final handler = FunctionCallHandler();

    // Act
    final result = await handler.execute<String>(
      function: () async => 'ignored',
      key: key,
      type: type,
    );

    // Assert
    expect(result, expectedResult);

    verify(
      mockPlatform.execute<String>(
        function: anyNamed('function'),
        key: key,
        type: type,
      ),
    ).called(1);
  });
}
