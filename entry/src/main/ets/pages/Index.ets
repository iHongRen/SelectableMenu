import {
  MenuContainer, SelectableMenuItem, SelectableModel, SelectableText
} from '@cxy/selecteablemenu'
import { InheritDemo } from './InheritDemo'
import { ComposeDemo } from './ComposeDemo'

@Entry
@Component
struct Index {
  @State useComposeMode: boolean = false

  build() {
    Navigation() {
      Column() {
        Row() {
          Button('继承模式')
            .type(ButtonType.Capsule)
            .backgroundColor(this.useComposeMode ? '#e0e0e0' : '#007AFF')
            .fontColor(this.useComposeMode ? '#999' : '#fff')
            .onClick(() => {
              this.useComposeMode = false
            })
            .margin({ right: 12 })

          Button('组合模式')
            .type(ButtonType.Capsule)
            .backgroundColor(this.useComposeMode ? '#007AFF' : '#e0e0e0')
            .fontColor(this.useComposeMode ? '#fff' : '#999')
            .onClick(() => {
              this.useComposeMode = true
            })
        }
        .margin({ top: 12, bottom: 12 })

        if (!this.useComposeMode) {
          InheritDemo()
        } else {
          ComposeDemo()
        }
      }
    }
    .title('聊天消息')
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .parallelGesture(
      TapGesture()
        .onAction((event) => {
          SelectableModel.onPageTap(event)
        })
    )
  }
}