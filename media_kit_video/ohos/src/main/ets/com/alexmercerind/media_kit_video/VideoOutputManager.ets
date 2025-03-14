// VideoOutputManager.ets
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { TextureRegistry } from '@ohos/flutter_ohos/index';
import { VideoOutput } from './VideoOutput';
import { TextureUpdateCallback } from './TextureUpdateCallback';

const TAG = "VideoOutputManager";

export class VideoOutputManager {
  private videoOutputs: Map<number, VideoOutput> = new Map();
  private textureRegistry: TextureRegistry;
  
  constructor(textureRegistry: TextureRegistry) {
    this.textureRegistry = textureRegistry;
  }
  
  public create(handle: number, textureUpdateCallback: TextureUpdateCallback): void {
    Log.i(TAG, `create: ${handle}`);
    
    if (!this.videoOutputs.has(handle)) {
      // 创建新的纹理注册
      const textureId = this.textureRegistry.getTextureId();
      const surfaceTextureEntry = this.textureRegistry.registerTexture(textureId);
      
      const videoOutput = new VideoOutput(surfaceTextureEntry, textureUpdateCallback);
      this.videoOutputs.set(handle, videoOutput);
    }
  }
  
  public dispose(handle: number): void {
    Log.i(TAG, `dispose: ${handle}`);
    
    const videoOutput = this.videoOutputs.get(handle);
    if (videoOutput) {
      videoOutput.dispose();
      this.videoOutputs.delete(handle);
    }
  }
  
  public setSurfaceSize(handle: number, width: number, height: number): void {
    Log.i(TAG, `setSurfaceSize: ${handle} ${width} ${height}`);
    
    const videoOutput = this.videoOutputs.get(handle);
    if (videoOutput) {
      videoOutput.setSurfaceSize(width, height);
    }
  }
}