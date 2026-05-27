/**
 * @fileName : SelectableConfig.ets
 * @author : @cxy
 * @date : 2026/5/27
 * @description : 可选择菜单配置类，支持通过回调配置而非继承使用
 */

import { SelectableMenuItem } from './SelectableModel'
import { SelectableModel } from './SelectableModel'

@Observed
export class SelectableConfig extends SelectableModel {
  public canCopyCallback?: () => boolean
  public copyTextCallback?: () => string
  public getMenusCallback?: (selectionStart: number, selectionEnd: number) => SelectableMenuItem[]

  public canCopy(): boolean {
    return this.canCopyCallback?.() ?? super.canCopy()
  }

  public copyText(): string {
    return this.copyTextCallback?.() ?? super.copyText()
  }

  public getMenus(): SelectableMenuItem[] {
    return this.getMenusCallback?.(this.selectionStart, this.selectionEnd) ?? super.getMenus()
  }
}