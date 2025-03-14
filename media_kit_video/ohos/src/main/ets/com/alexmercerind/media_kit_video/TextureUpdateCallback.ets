// TextureUpdateCallback.ets
export interface TextureUpdateCallback {
  onTextureUpdate(id: number, wid: number, width: number, height: number): void;
}