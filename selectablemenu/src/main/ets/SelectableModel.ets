/**
 * @fileName : SelectableModel.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 数据模型
 */

export class SelectableMenuItem {
  title: string = ''
  icon: ResourceStr = ''
  action?: () => void
}

@Observed
export class SelectableModel {
  private static pageTapListeners: Set<(event?: BaseGestureEvent) => void> = new Set()
  public selectionStart: number = -1
  public selectionEnd: number = -1
  public longpressPopup: boolean = false
  public onDidMenuItem?: (isCopy?: boolean, isSelectAll?: boolean) => void

  public static addOnPageTapListener(listener: (event?: BaseGestureEvent) => void): void {
    SelectableModel.pageTapListeners.add(listener)
  }

  public static removeOnPageTapListener(listener: (event?: BaseGestureEvent) => void): void {
    SelectableModel.pageTapListeners.delete(listener)
  }

  public static onPageTap(event?: BaseGestureEvent): void {
    SelectableModel.pageTapListeners.forEach((listener: (event?: BaseGestureEvent) => void) => listener(event))
  }

  // 需要子类覆盖实现
  public canCopy() {
    return false
  }

  // 需要子类覆盖实现
  public copyText(): string {
    return ''
  }

  // 需要子类覆盖实现
  public getMenus(): SelectableMenuItem[] {
    return []
  }
}
