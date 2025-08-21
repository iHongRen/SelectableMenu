/**
 * @fileName : SelectableManager.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 选择管理器
 */

export class SelectableManager {
  public static readonly shared = new SelectableManager()
  public onPageClick?: (event: GestureEvent) => void

  private constructor() {
  }
}