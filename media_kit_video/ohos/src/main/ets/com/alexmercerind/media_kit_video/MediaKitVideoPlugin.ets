import Log from "@ohos/flutter_ohos/src/main/ets/util/Log"
import {
    AbilityPluginBinding,
    FlutterPlugin,
    FlutterPluginBinding,
} from "@ohos/flutter_ohos/index"
import { TextureRegistry } from "@ohos/flutter_ohos/index"
import MethodChannel, {
    MethodCallHandler,
    MethodResult,
} from "@ohos/flutter_ohos/src/main/ets/plugin/common/MethodChannel"
import MethodCall from "@ohos/flutter_ohos/src/main/ets/plugin/common/MethodCall"
import { VideoOutputManager } from "./VideoOutputManager"
import { TextureUpdateCallback } from "./TextureUpdateCallback"
import { Utils } from "./Utils"

const TAG = "MediaKitVideoPlugin"
interface Rect {
  left: number;
  top: number;
  width: number;
  height: number;
}
class TextureUpdateCallbackImpl implements TextureUpdateCallback {
  private handle: number;
  private channel:  MethodChannel | null; // 根据实际类型替换any

  constructor(handle: number, channel:  MethodChannel | null) {
    this.handle = handle;
    this.channel = channel;
  }

  onTextureUpdate(id: number, wid: number, width: number, height: number): void {
    const dict: Record<string, number> = { "left": 0, "top": 0, "width": width, "height": height }
    this.channel?.invokeMethod("VideoOutput.Resize", {
      handle: this.handle,
      id: id,
      wid: wid,
      rect: dict
    });
  }
}
export class MediaKitVideoPlugin implements FlutterPlugin, MethodCallHandler {
    private channelName: string = "com.alexmercerind/media_kit_video"
    private channel: MethodChannel | null = null
    private videoOutputManager: VideoOutputManager | null = null

    getUniqueClassName(): string {
        return TAG
    }

    onAttachedToEngine(binding: FlutterPluginBinding): void {
        this.channel = new MethodChannel(
            binding.getBinaryMessenger(),
            this.channelName
        )
        this.channel?.setMethodCallHandler(this)
        this.videoOutputManager = new VideoOutputManager(
            binding.getTextureRegistry()
        )
        Log.i(TAG, "Attached to engine")
    }

    onDetachedFromEngine(binding: FlutterPluginBinding): void {
        this.channel?.setMethodCallHandler(null)
        this.channel = null
        Log.i(TAG, "Detached from engine")
    }

    onMethodCall(call: MethodCall, result: MethodResult): void {
        try {
            switch (call.method) {
                case "VideoOutputManager.Create": {
                    const handle = parseInt(call.argument("handle"))

                    // 创建一个符合 TextureUpdateCallback 接口的对象
                    const callback = new TextureUpdateCallbackImpl(handle, this.channel);

                    this.videoOutputManager?.create(handle, callback)
                    result.success(null)
                    break
                }

                case "VideoOutputManager.SetSurfaceSize": {
                    const handle = parseInt(call.argument("handle"))
                    const width = parseInt(call.argument("width"))
                    const height = parseInt(call.argument("height"))

                    this.videoOutputManager?.setSurfaceSize(
                        handle,
                        width,
                        height
                    )
                    result.success(null)
                    break
                }

                case "VideoOutputManager.Dispose": {
                    const handle = parseInt(call.argument("handle"))

                    this.videoOutputManager?.dispose(handle)
                    result.success(null)
                    break
                }

                case "Utils.IsEmulator": {
                    result.success(Utils.isEmulator())
                    break
                }

                default: {
                    result.notImplemented()
                    break
                }
            }
        } catch (e) {
            Log.e(TAG, `Error handling method call: ${e}`)
            result.error("EXCEPTION", `Error: ${e}`, null)
        }
    }

    onAttachedToAbility(binding: AbilityPluginBinding): void {
        // 保存Ability上下文，如需要
    }

    onDetachedFromAbility(): void {
        // 清理Ability相关资源
    }
}
