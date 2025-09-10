#include "include/function_call_handler/function_call_handler_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "function_call_handler_plugin.h"

void FunctionCallHandlerPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  function_call_handler::FunctionCallHandlerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
