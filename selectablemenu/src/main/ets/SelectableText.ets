/**
 * @fileName : SelectableText.ets
 * @author : @cxy
 * @date : 2025/8/21
 * @description : 可选择文本组件
 */


import { LengthMetrics } from '@kit.ArkUI'
import { SelectableMenu } from './SelectableMenu'
import { SelectableModel } from './SelectableModel'


@Component
export struct SelectableText {
  @ObjectLink model: SelectableModel
  @Prop caretColor: ResourceColor
  @Prop selectedBackgroundColor: ResourceColor
  @BuilderParam slot: () => void
  @State showPopup: boolean = false
  @State start: number = -1
  @State end: number = 0
  private timeout: number = 0
  private lastHideTime: number = 0
  private msgArea?: Area

  aboutToAppear(): void {
    this.cancelSelect()
    this.model.onMenuItemClick = (isSelectAll: boolean = false, delay: number = 0) => {
      setTimeout(() => {
        if (isSelectAll) {
          this.selectAll()
        } else {
          this.cancelSelect()
        }
      }, delay)
    }
  }

  cancelSelect() {
    this.selectChange(-1, 0)
    this.hideMenuPopup()
  }

  selectAll() {
    const length = this.model.copyText().length
    this.selectChange(0, length)
    this.showMenuPopup()
  }

  startTimer() {
    clearInterval(this.timeout)
    this.timeout = setTimeout(() => {
      if (this.end - this.start > 0) {
        this.showMenuPopup()
      }
    }, 500)
  }

  showMenuPopup() {
    SelectableModel.onPageTap = (event: GestureEvent) => {
      if (this.msgArea && this.start >= 0 && this.end >= 0 && event.fingerList?.length > 0) {
        const x = event.fingerList[0].globalX
        const y = event.fingerList[0].globalY

        if (!this.isPointInComponent(x, y)) {
          this.cancelSelect()
        }
      }
    }
    this.showPopup = true
  }

  hideMenuPopup() {
    this.showPopup = false
    clearTimeout(this.timeout)
    // SelectableModel.onPageTap = undefined
    this.lastHideTime = new Date().getTime()
  }

  isPointInComponent(x: number, y: number): boolean {
    if (!this.msgArea) {
      return false
    }
    const w = this.msgArea.width as number
    const h = this.msgArea.height as number
    const left = this.msgArea.globalPosition.x as number
    const right = left + w
    const top = this.msgArea.globalPosition.y as number
    const bottom = top + h
    return x >= left && x <= right && y >= top && y <= bottom
  }

  selectChange(selectionStart: number, selectionEnd: number) {
    this.model.selectionStart = selectionStart
    this.model.selectionEnd = selectionEnd
    this.start = selectionStart
    this.end = selectionEnd
    this.model.onTextSelectionChange?.(selectionStart, selectionEnd)
  }

  build() {
    Text() {
      this.slot()
    }
    .caretColor(this.caretColor)
    .selectedBackgroundColor(this.selectedBackgroundColor)
    .lineSpacing(LengthMetrics.vp(6))
    .copyOption(CopyOptions.LocalDevice)
    .selection(this.start, this.end)
    .onTextSelectionChange((selectionStart: number, selectionEnd: number) => {
      this.selectChange(selectionStart, selectionEnd)
      this.startTimer()
    })
    .bindSelectionMenu(TextSpanType.TEXT, this.customBuilder, TextResponseType.LONG_PRESS, {
      onAppear: (start: number, end: number) => {
        if (!this.showPopup) {
          if (this.model.canCopy()) {
            this.selectAll()
          }
        }
      },
      onDisappear: () => {
        this.hideMenuPopup()
      }
    })
    .bindPopup(this.showPopup, {
      builder: this.menuPopup(),
      placement: Placement.Top,
      popupColor: '#e6000000',
      backgroundBlurStyle: BlurStyle.NONE,
      radius: 5,
      mask: false,
      onStateChange: (e) => {
        if (!e.isVisible) {
          this.hideMenuPopup()
        }
      },
    })
    .onVisibleAreaChange([0, 1], (isExpanding: boolean, currentRatio: number) => {
      if (!isExpanding && currentRatio === 0) {
        this.cancelSelect()
      }
    })
    .priorityGesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture({ count: 2, fingers: 1 })
          .onAction(() => {
          })
      ))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.msgArea = newValue
    })
  }

  @Builder
  customBuilder() {
    Column()
      .width(1)
      .height(1)
      .onVisibleAreaChange([0, 1], (isExpanding: boolean, currentRatio: number) => {
        if (!isExpanding && currentRatio === 0) {
          this.hideMenuPopup()
        } else if (isExpanding && currentRatio === 1) {
          if (this.end - this.start > 0) {
            const diff = new Date().getTime() - this.lastHideTime
            if (diff > 60) {
              this.showMenuPopup()
            }
          }
        }
      })
  }

  @Builder
  menuPopup() {
    SelectableMenu({ model: this.model })
  }
}

