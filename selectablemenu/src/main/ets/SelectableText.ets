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
  @Prop text: string
  @Prop textAlign: TextAlign
  @Prop textOverflow: TextOverflowOptions
  @Prop maxLines: number
  @Prop lineHeight: number | string | Resource
  @Prop decoration: DecorationStyleInterface
  @Prop baselineOffset: number | string
  @Prop letterSpacing: number | string
  @Prop minFontSize: number | string | Resource
  @Prop maxFontSize: number | string | Resource
  @Prop fontColor: ResourceColor
  @Prop fontSize: number | string | Resource
  @Prop fontStyle: FontStyle
  @Prop fontWeight: FontWeight
  @Prop fontSettingOptions: FontSettingOptions
  @Prop fontFamily: string | Resource
  @Prop textDraggable: boolean // = draggable
  @Prop textShadow: ShadowOptions | Array<ShadowOptions>
  @Prop heightAdaptivePolicy: TextHeightAdaptivePolicy
  @Prop textIndent: Length
  @Prop wordBreak: WordBreak
  @Prop ellipsisMode: EllipsisMode
  @Prop enableDataDetector: boolean
  @Prop dataDetectorConfig: TextDataDetectorConfig
  @Prop fontFeature: string
  @Prop lineSpacing: LengthMetrics = LengthMetrics.vp(5)
  @Prop privacySensitive: boolean
  @Prop lineBreakStrategy: LineBreakStrategy
  @Prop minFontScale: number | Resource
  @Prop maxFontScale: number | Resource
  @Prop halfLeading: boolean
  @Prop enableHapticFeedback: boolean
  @Prop caretColor: ResourceColor
  @Prop selectedBackgroundColor: ResourceColor
  @State textModifier: AttributeModifier<TextAttribute> | undefined = undefined //其他属性或高版本API的可通过它设置
  controller?: TextController
  @BuilderParam childComponent: () => void //子组件,可以包含Span、ImageSpan、SymbolSpan和ContainerSpan
  @Prop popupColor: ResourceColor = '#e6000000'
  @Prop popupRadius: number = 5
  @Prop placement: Placement = Placement.Top
  ///////////// 下面的作为私有属性 ////////////////////////////////////////////////////////////
  @State showPopup: boolean = false
  @State start: number = -1
  @State end: number = 0
  private timeout: number = 0
  private lastHideTime: number = 0
  private myArea?: Area

  aboutToAppear(): void {
    this.cancelSelect()
    this.model.onDidMenuItem = (isSelectAll: boolean = false, delay: number = 0) => {
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
    SelectableModel.onPageTap = (event?: BaseGestureEvent) => {
      if (event && this.myArea && this.start >= 0 && this.end >= 0 && event.fingerList?.length > 0) {
        const x = event.fingerList[0].globalX
        const y = event.fingerList[0].globalY

        if (!this.isPointInComponent(x, y)) {
          this.cancelSelect()
          SelectableModel.onPageTap = undefined
        }
      } else if (!event) {
        this.cancelSelect()
        SelectableModel.onPageTap = undefined
      }
    }

    this.showPopup = true
  }

  hideMenuPopup() {
    this.showPopup = false
    clearTimeout(this.timeout)
    this.lastHideTime = new Date().getTime()
  }

  isPointInComponent(x: number, y: number): boolean {
    if (!this.myArea) {
      return false
    }
    const w = this.myArea.width as number
    const h = this.myArea.height as number
    const left = this.myArea.globalPosition.x as number
    const right = left + w
    const top = this.myArea.globalPosition.y as number
    const bottom = top + h
    return x >= left && x <= right && y >= top && y <= bottom
  }

  selectChange(selectionStart: number, selectionEnd: number) {
    this.model.selectionStart = selectionStart
    this.model.selectionEnd = selectionEnd
    this.start = selectionStart
    this.end = selectionEnd
  }

  build() {
    Text(this.text, { controller: this.controller }) {
      this.childComponent?.()
    }
    .textAlign(this.textAlign)
    .textOverflow(this.textOverflow)
    .maxLines(this.maxLines)
    .lineHeight(this.lineHeight)
    .decoration(this.decoration)
    .baselineOffset(this.baselineOffset)
    .letterSpacing(this.letterSpacing)
    .minFontSize(this.minFontSize)
    .maxFontSize(this.maxFontSize)
    .fontColor(this.fontColor)
    .fontSize(this.fontSize)
    .fontStyle(this.fontStyle)
    .fontWeight(this.fontWeight, this.fontSettingOptions)
    .fontFamily(this.fontFamily)
    .draggable(this.textDraggable)
    .textShadow(this.textShadow)
    .heightAdaptivePolicy(this.heightAdaptivePolicy)
    .textIndent(this.textIndent)
    .wordBreak(this.wordBreak)
    .ellipsisMode(this.ellipsisMode)
    .enableDataDetector(this.enableDataDetector)
    .dataDetectorConfig(this.dataDetectorConfig)
    .fontFeature(this.fontFeature)
    .lineSpacing(this.lineSpacing)
    .privacySensitive(this.privacySensitive)
    .lineBreakStrategy(this.lineBreakStrategy)
    .enableHapticFeedback(this.enableHapticFeedback)
    .caretColor(this.caretColor)
    .selectedBackgroundColor(this.selectedBackgroundColor)
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
      placement: this.placement,
      popupColor: this.popupColor,
      backgroundBlurStyle: BlurStyle.NONE,
      radius: this.popupRadius,
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
      this.myArea = newValue
    })
    .attributeModifier(this.textModifier)
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

