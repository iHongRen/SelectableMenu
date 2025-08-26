/**
 * @fileName : MenuContainer.ets
 * @author : @cxy
 * @date : 2025/8/25
 * @description : 弹出菜单容器组件
 */
import { SelectableMenu } from './SelectableMenu'
import { SelectableModel } from './SelectableModel'

@Component
export struct MenuContainer {
  @BuilderParam childComponent: () => void
  @ObjectLink model: SelectableModel
  @Prop popupColor: ResourceColor = '#e6000000'
  @Prop popupRadius: number = 5
  @Prop placement: Placement = Placement.Top
  @Prop menuItemWidth: number = 50
  @Prop maxColumnCount: number = 5

  aboutToAppear(): void {
    this.model.onDidMenuItem = () => {
      setTimeout(() => {
        this.model.longpressPopup = false
      }, 50)
    }
  }

  build() {
    Column() {
      this.childComponent?.()
    }
    .bindPopup(this.model.longpressPopup, {
      builder: this.menuPopup(),
      placement: this.placement,
      popupColor: this.popupColor,
      backgroundBlurStyle: BlurStyle.NONE,
      radius: this.popupRadius,
      onStateChange: (e) => {
        if (!e.isVisible) {
          this.model.longpressPopup = false
        }
      }
    })
    .priorityGesture(
      LongPressGesture()
        .onAction((event: GestureEvent) => {
          if (event) {
            SelectableModel.onPageTap?.()
            this.model.longpressPopup = true
          }
        })
    )
  }

  @Builder
  menuPopup() {
    SelectableMenu({
      model: this.model,
      menuItemWidth: this.menuItemWidth,
      maxColumnCount: this.maxColumnCount
    })
  }
}