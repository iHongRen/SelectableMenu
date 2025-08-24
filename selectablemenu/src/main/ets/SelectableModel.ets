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
  public static onPageTap?: (event: BaseGestureEvent) => void
  public selectionStart: number = -1
  public selectionEnd: number = -1
  public longpressPopup: boolean = false
  public onTextSelectionChange?: (start: number, end: number) => void
  public onMenuItemClick?: (isSelectAll?: boolean, delay?: number) => void

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