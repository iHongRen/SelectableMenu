/**
 * @fileName : SelectableModel.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 数据模型
 */

@Observed
export class SelectableModel {
  _selectionStart: number = -1
  _selectionEnd: number = -1
  _longpressPopup: boolean = false
  onTextSelectionChange?: (selectionStart: number, selectionEnd: number) => void

  canCopy() {
    return true
  }

  copyText(): string {
    return ''
  }
}