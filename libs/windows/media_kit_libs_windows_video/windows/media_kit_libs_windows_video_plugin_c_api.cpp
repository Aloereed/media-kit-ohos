/*
 * @Author: 
 * @Date: 2025-03-13 12:53:51
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2025-03-13 12:59:06
 * @Description: file content
 */
#include "include/media_kit_libs_windows_video/media_kit_libs_windows_video_plugin_c_api.h"

#include <iostream>

#include <flutter/plugin_registrar_windows.h>

void MediaKitLibsWindowsVideoPluginCApiRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  std::cout << "package:media_kit_libs_windows_video registered." << std::endl;
}
