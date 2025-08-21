/**
 * @fileName : SelectableMenu.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 弹出菜单
 */
import { SelectableModel } from "./SelectableModel"


export class SelectableMenuItem {
  title: string = ''
  icon: ResourceStr = ''
  action?: () => void
  data?: SelectableModel
}


interface ItemWrap {
  item: SelectableMenuItem
}

@Component
export struct SelectableMenu {
  @ObjectLink model: SelectableModel
  @State menus: SelectableMenuItem[] = []
  @State columnsTemplate: string = ''
  @State gridWidth: number = 0

  aboutToAppear(): void {
    this.configMenus()
    this.model.onTextSelectionChange = (selectionStart: number, selectionEnd: number) => {
      this.configMenus()
    }
  }

  configMenus() {
    // this.menus = MsgPopupHelper.getMsgMenus(this.msg)
    const columnCount = Math.min(5, this.menus.length)
    this.gridWidth = columnCount * 50
    this.columnsTemplate = '1fr '.repeat(columnCount).trimEnd()
  }

  build() {
    Grid() {
      ForEach(this.menus, (item: SelectableMenuItem) => {
        this.menuItemBuilder({ item: item })
      }, (item: SelectableMenuItem) => item.title)
    }
    .columnsTemplate(this.columnsTemplate)
    .width(this.gridWidth)
    .maxCount(this.menus.length)
  }

  @Builder
  menuItemBuilder(wrap: ItemWrap) {
    GridItem() {
      Column({ space: 5 }) {
        Image(wrap.item.icon).width(16).height(16).objectFit(ImageFit.Contain)
        Text(wrap.item.title).fontSize(11).fontColor('#fff')
      }
      .width(50)
      .padding({ top: 10, bottom: 10 })
      .onClick(() => {
        wrap.item.action?.()
        if (wrap.item.data && !wrap.item.data.canCopy()) {
          wrap.item.data._longpressPopup = false
          wrap.item.data._selectionStart = -1
          wrap.item.data._selectionEnd = -1
          // ChatMsgEmitter.emit(ChatMsgEventName.MsgChanged, wrap.item.msg)
        }
      })
    }
  }
}