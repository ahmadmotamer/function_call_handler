#ifndef FLUTTER_PLUGIN_FUNCTION_CALL_HANDLER_PLUGIN_H_
#define FLUTTER_PLUGIN_FUNCTION_CALL_HANDLER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace function_call_handler {

class FunctionCallHandlerPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FunctionCallHandlerPlugin();

  virtual ~FunctionCallHandlerPlugin();

  // Disallow copy and assign.
  FunctionCallHandlerPlugin(const FunctionCallHandlerPlugin&) = delete;
  FunctionCallHandlerPlugin& operator=(const FunctionCallHandlerPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace function_call_handler

#endif  // FLUTTER_PLUGIN_FUNCTION_CALL_HANDLER_PLUGIN_H_
