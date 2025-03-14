/*
 * @Author: 
 * @Date: 2025-03-13 12:53:51
 * @LastEditors: 
 * @LastEditTime: 2025-03-13 15:38:02
 * @Description: file content
 */
/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// {@template adaptive_video_controls}
///
/// [Video] controls based on the running platform.
///
/// {@endtemplate}
Widget AdaptiveVideoControls(VideoState state) {
  switch (Theme.of(state.context).platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.ohos:
      return MaterialVideoControls(state);
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
    case TargetPlatform.linux:
      return MaterialDesktopVideoControls(state);
    default:
      return NoVideoControls(state);
  }
}
