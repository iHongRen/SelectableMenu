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
  @Prop menuItemWidth: number = 50
  @Prop maxColumnCount: number = 5

  build() {
    Grid() {
      ForEach(this.model.getMenus(), (item: SelectableMenuItem) => {
        this.menuItemBuilder(item)
      }, (item: SelectableMenuItem) => item.title)
    }
    .columnsTemplate(this.getColumnsTemplate())
    .width(this.getGridWidth())
    .maxCount(this.model.getMenus().length)
  }

  getGridWidth(): number {
    const columnCount = Math.min(this.maxColumnCount, this.model.getMenus().length)
    return columnCount * this.menuItemWidth
  }

  getColumnsTemplate(): string {
    const columnCount = Math.min(this.maxColumnCount, this.model.getMenus().length)
    return '1fr '.repeat(columnCount).trimEnd()
  }

  @Builder
  menuItemBuilder(item: SelectableMenuItem) {
    GridItem() {
      Column({ space: 5 }) {
        Image(item.icon).width(16).height(16).objectFit(ImageFit.Contain)
        Text(item.title).fontSize(11).fontColor('#fff')
      }
      .width(this.menuItemWidth)
      .padding({ top: 10, bottom: 10 })
      .onClick(() => {
        item.action?.()
      })
    }
  }
}