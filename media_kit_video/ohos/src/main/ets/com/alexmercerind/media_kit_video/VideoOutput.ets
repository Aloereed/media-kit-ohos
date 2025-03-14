// VideoOutput.ets
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { SurfaceTextureEntry } from '@ohos/flutter_ohos/index';
import { TextureUpdateCallback } from './TextureUpdateCallback';
// import { Timer } from '@ohos/timer';  


const TAG = "VideoOutput";

export class VideoOutput {
  private id: number = 0;
  private wid: number = 0;
  private textureUpdateCallback: TextureUpdateCallback;
  private surfaceProducer: SurfaceTextureEntry;
  private width: number = 1;
  private height: number = 1;
  
  // 用于模拟Java里的deleteGlobalObjectRef集合，避免重复删除
  private static deletedGlobalObjectRefs: Set<number> = new Set<number>();
  
  constructor(surfaceProducer: SurfaceTextureEntry, textureUpdateCallback: TextureUpdateCallback) {
    this.surfaceProducer = surfaceProducer;
    this.textureUpdateCallback = textureUpdateCallback;
    
    // 初始化默认大小
    this.setSurfaceSize(1, 1, true);
  }
  
  public dispose(): void {
    try {
      // 通知表面被销毁
      this.onSurfaceDestroyed();
      
      // 释放Surface资源
      this.surfaceProducer.release();
    } catch (e) {
      Log.e(TAG, `Error in dispose: ${e}`);
    }
  }
  
  public setSurfaceSize(width: number, height: number, force: boolean = false): void {
    try {
      // 检查尺寸是否需要更新
      if (!force && this.width === width && this.height === height) {
        return;
      }
      
      this.width = width;
      this.height = height;
      
      // 鸿蒙的TextureRegistry设置纹理缓冲区大小
      this.surfaceProducer.getSurfaceId(); // 确保表面存在
      
      // 通知表面创建/更新
      this.onSurfaceCreated();
    } catch (e) {
      Log.e(TAG, `Error in setSurfaceSize: ${e}`);
    }
  }
  
  /**
   * 当Surface创建/更新时调用
   */
  private onSurfaceCreated(): void {
    Log.i(TAG, "onSurfaceCreated");
    this.id = this.surfaceProducer.getTextureId();
    this.wid = this.surfaceProducer.getNativeWindowId();
    
    // 通知回调
    this.textureUpdateCallback.onTextureUpdate(
      this.id, this.wid, this.width, this.height);
  }
  
  /**
   * 当Surface销毁时调用
   */
  private onSurfaceDestroyed(): void {
    Log.i(TAG, "onSurfaceDestroyed");
    
    // 通知回调，wid为0表示销毁
    this.textureUpdateCallback.onTextureUpdate(
      this.id, 0, this.width, this.height);
    
    // 延迟删除原生窗口引用
    if (this.wid != 0) {
      const widReference = this.wid;
      setTimeout(() => {
        VideoOutput.deleteGlobalObjectRef(widReference);
      }, 5000);
    }
  }
  
  /**
   * 创建全局对象引用 - 在鸿蒙中简化实现
   * 这里作为兼容性代码保留，实际由native层处理
   */
  private static newGlobalObjectRef(object: object): number {
    Log.i(TAG, `newGlobalObjectRef: object = ${object}`);
    // 实际应该调用底层实现
    // 这里返回一个代表性的非0值表示成功
    return Date.now(); // 返回当前时间戳作为临时ID
  }
  
  /**
   * 删除全局对象引用 - 在鸿蒙中简化实现
   * 这里作为兼容性代码保留，实际由native层处理
   */
  private static deleteGlobalObjectRef(ref: number): void {
    if (VideoOutput.deletedGlobalObjectRefs.has(ref)) {
      Log.i(TAG, `deleteGlobalObjectRef: ref = ${ref} ALREADY DELETED`);
      return;
    }
    
    if (VideoOutput.deletedGlobalObjectRefs.size > 100) {
      VideoOutput.deletedGlobalObjectRefs.clear();
    }
    
    VideoOutput.deletedGlobalObjectRefs.add(ref);
    Log.i(TAG, `deleteGlobalObjectRef: ref = ${ref}`);
    
    // 实际应该调用底层实现
    // 在这里我们只是记录状态
  }
}