import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { uri } from '@kit.ArkTS';
import Logger from '@ohos.hilog'; // 使用官方日志库替换自定义Log

const TAG = "MediaKitOhosHelper";
const DOMAIN = 0x0001;

/**
 * 鸿蒙系统下的媒体套件辅助类
 */
export default class MediaKitOhosHelper {
  private static applicationContext: common.Context | null = null;
  private static abilityContext: common.Context | null = null;

  /**
   * 设置应用上下文
   */
  static setApplicationContext(context: common.Context): void {
    MediaKitOhosHelper.applicationContext = context;
    Logger.info(DOMAIN, TAG, "Application context set successfully");
  }

  /**
   * 设置Ability上下文
   */
  static setAbilityContext(context: common.Context | null): void {
    MediaKitOhosHelper.abilityContext = context;
  }

  /**
   * 从assets目录复制文件到应用内部存储
   */
  static async copyAssetToFilesDir(assetName: string): Promise<string> {
    if (!MediaKitOhosHelper.applicationContext) {
      Logger.error(DOMAIN, TAG, "Application context is null");
      return "";
    }

    try {
      const context = MediaKitOhosHelper.applicationContext;
      const destDir = context.filesDir;
      const destPath = `${destDir}/${assetName}`;

      // 检查目标文件是否已存在
      try {
        await fs.access(destPath);
        return destPath;
      } catch (error) {
        // 文件不存在，继续复制
      }

      // 获取资源文件描述符
      const rawFd = await context.resourceManager.getRawFd(assetName);
      
      // 读取文件内容
      const buffer = new ArrayBuffer(rawFd.length);
      await fs.read(rawFd.fd, buffer, { offset: rawFd.offset });
      
      // 写入到目标文件
      const file = await fs.open(destPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      await fs.write(file.fd, buffer);
      await fs.close(file.fd);
      await fs.close(rawFd.fd);

      return destPath;
    } catch (e) {
      const err = e as BusinessError;
      Logger.error(DOMAIN, TAG, `Failed to copy asset: ${err.message}`);
      return "";
    }
  }

  /**
   * 打开文件描述符
   */
  static async openFileDescriptor(uriStr: string): Promise<number> {
    const context = MediaKitOhosHelper.abilityContext || MediaKitOhosHelper.applicationContext;
    if (!context) {
      Logger.error(DOMAIN, TAG, "Context is null");
      return -1;
    }

    try {

      const file = await fs.open(uriStr, fs.OpenMode.READ_ONLY);
      return file.fd;
    } catch (e) {
      const err = e as BusinessError;
      Logger.error(DOMAIN, TAG, `Failed to open file descriptor: ${err.message}`);
      return -1;
    }
  }
}
