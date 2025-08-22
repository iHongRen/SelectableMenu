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
  public static onPageTap?: (event: GestureEvent) => void
  public selectionStart: number = -1
  public selectionEnd: number = -1
  public longpressPopup: boolean = false
  public onTextSelectionChange?: (start: number, end: number) => void
  public onMenuItemClick?: (isSelectAll?: boolean, delay?: number) => void

  public canCopy() {
    return true
  }

  public copyText(): string {
    return ''
  }

  public getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []
    return menus
  }

  afterAction() {
    if (!this.canCopy()) {
      this.longpressPopup = false
      this.selectionStart = -1
      this.selectionEnd = -1
      // ChatMsgEmitter.emit(ChatMsgEventName.MsgChanged, wrap.item.msg)
    }
  }
}