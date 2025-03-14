import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { AbilityPluginBinding, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos/index';
import MediaKitOhosHelper from './MediaKitOhosHelper';

const TAG = "MediaKitLibsOhosVideoPlugin";

export class MediaKitLibsOhosVideoPlugin implements FlutterPlugin {
  getUniqueClassName(): string {
    return TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    Log.i(TAG, "package:media_kit_libs_ohos_video attached.");
    
    try {
      // 保存应用上下文以便在MediaKitOhosHelper中访问，例如加载捆绑资源
      MediaKitOhosHelper.setApplicationContext(binding.getApplicationContext());
      Log.i(TAG, "Saved application context.");
    } catch (e) {
      Log.e(TAG, `Error saving context: ${e}`);
    }
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    Log.i(TAG, "package:media_kit_libs_ohos_video detached.");
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    // 可能需要保存Ability引用，如果需要访问Ability特定功能
    MediaKitOhosHelper.setAbilityContext(binding.getAbility().context);
  }

  onDetachedFromAbility(): void {
    // 清理Ability引用
    MediaKitOhosHelper.setAbilityContext(null);
  }
}