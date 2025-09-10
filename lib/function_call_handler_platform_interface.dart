import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'function_call_handler.dart';
import 'function_call_handler_method_channel.dart';

abstract class FunctionCallHandlerPlatform extends PlatformInterface {
  FunctionCallHandlerPlatform() : super(token: _token);
  static final Object _token = Object();

  static FunctionCallHandlerPlatform _instance =
      FunctionCallHandlerMethodChannel();

  static FunctionCallHandlerPlatform get instance => _instance;

  static set instance(FunctionCallHandlerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<T> execute<T>({
    required Future<T> Function() function,
    required String key,
    required RequestType type,
  });
}
