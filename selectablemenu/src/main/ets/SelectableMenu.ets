/**
 * @fileName : SelectableMenu.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 弹出菜单
 */
import { SelectableMenuItem, SelectableModel } from "./SelectableModel"


@Component
export struct SelectableMenu {
  @ObjectLink model: SelectableModel
  @State menus: SelectableMenuItem[] = []
  @State columnsTemplate: string = ''
  @State gridWidth: number = 0
  @Prop gridItemWidth: number = 50

  aboutToAppear(): void {
    this.configMenus()
    this.model.onTextSelectionChange = (start: number, end: number) => {
      this.configMenus()
    }
  }

  configMenus() {
    this.menus = this.model.getMenus()
    const columnCount = Math.min(5, this.menus.length)
    this.gridWidth = columnCount * this.gridItemWidth
    this.columnsTemplate = '1fr '.repeat(columnCount).trimEnd()
  }

  build() {
    Grid() {
      ForEach(this.menus, (item: SelectableMenuItem) => {
        this.menuItemBuilder(item)
      }, (item: SelectableMenuItem) => item.title)
    }
    .columnsTemplate(this.columnsTemplate)
    .width(this.gridWidth)
    .maxCount(this.menus.length)
  }

  @Builder
  menuItemBuilder(item: SelectableMenuItem) {
    GridItem() {
      Column({ space: 5 }) {
        Image(item.icon).width(16).height(16).objectFit(ImageFit.Contain)
        Text(item.title).fontSize(11).fontColor('#fff')
      }
      .width(this.gridItemWidth)
      .padding({ top: 10, bottom: 10 })
      .onClick(() => {
        item.action?.()
      })
    }
  }
}