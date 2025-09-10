import 'function_call_handler.dart';
import 'function_call_handler_platform_interface.dart';

class FunctionCallHandlerWeb extends FunctionCallHandlerPlatform {
  final FunctionCallManager _manager = FunctionCallManager();

  @override
  Future<T> execute<T>({
    required Future<T> Function() function,
    required String key,
    required RequestType type,
  }) async {
    // Web implementation: just delegate
    return _manager.execute<T>(function: function, key: key, type: type);
  }
}
