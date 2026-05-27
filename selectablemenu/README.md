# SelectableMenu - 鸿蒙文本选择菜单组件

![GitHub release](https://img.shields.io/github/v/release/iHongRen/SelectableMenu)  ![License](https://img.shields.io/badge/License-Apache%202.0-green.svg) ![GitHub Stars](https://img.shields.io/github/stars/iHongRen/SelectableMenu.svg)

文本选择菜单组件，主要用于聊天对话框中的长按文本选择和操作功能。

## 功能特性

- 文本选择：支持长按选择文本
- 自动全选：长按时默认选中全部文本内容
- 自定义菜单：支持自定义菜单项，包括图标、标题和操作

## 安装使用

```bash
ohpm install @cxy/selecteablemenu
```

或在项目 `oh-package.json5` 添加依赖，然后同步项目

```json
{
  "dependencies": {
    "@cxy/selecteablemenu": "^1.1.0"
  }
}
```

<img src="https://7up.pics/images/2025/08/26/Screenshot_20250826103252967.jpeg" width=320>

## 完整示例 - [查看demo](https://github.com/iHongRen/SelectableMenu)

```typescript
import {
  MenuContainer, SelectableMenuItem, SelectableModel, SelectableText
} from '@cxy/selecteablemenu'

enum MessageType {
  Text = 0,
  Image = 1
}

/**
 * ChatMessage 需要继承至 SelectableModel
 */
@Observed
class ChatMessage extends SelectableModel {
  id: number = 0
  type: MessageType = MessageType.Text
  text: string = ''
  imageUrl: ResourceStr = ''

  constructor(id: number) {
    super()
    this.id = id
  }

  /**
   * 覆盖父类方法，消息是否可以复制
   * @returns
   */
  public canCopy(): boolean {
    return this.type === MessageType.Text && this.text.length > 0
  }

  /**
   * 覆盖父类方法，消息可复制的文本
   * @returns
   */
  public copyText(): string {
    return this.text
  }

  /**
   * 覆盖父类方法，消息的弹出菜单项
   * @returns 菜单数组
   */
  public getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []

    if (this.canCopy()) {
      menus.push({
        title: '复制',
        icon: $r("app.media.copy"),
        action: () => {
          // 复制文本到剪贴板
          const text = this.copyText()
          // TODO: 调用系统复制API
          // ...

          this.onDidMenuItem?.(true)
        }
      })
    }

    if (this.canCopy() && this.selectionStart >= 0 && this.selectionEnd > 0 &&
      this.selectionEnd - this.selectionStart < this.copyText().length) {
      menus.push({
        title: '全选',
        icon: $r("app.media.edit"),
        action: () => {
          this.onDidMenuItem?.(false, true)
        }
      })
    }

    menus.push({
      title: '转发',
      icon: $r("app.media.forward"),
      action: () => {
        // TODO: 处理转发逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '收藏',
      icon: $r("app.media.favor"),
      action: () => {
        // TODO: 处理收藏逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '删除',
      icon: $r("app.media.delete"),
      action: () => {
        // TODO: 处理删除逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    menus.push({
      title: '多选',
      icon: $r("app.media.sort"),
      action: () => {
        // TODO： 处理多选逻辑
        // ...

        this.onDidMenuItem?.()
      }
    })

    return menus
  }
}

@Entry
@Component
struct Index {
  @State messages: Array<ChatMessage> = []

  aboutToAppear(): void {
    this.initMessages()
  }

  initMessages() {
    const message1 = new ChatMessage(1)
    message1.text = '这是一条可以长按选择的文本消息'

    const message2 = new ChatMessage(2)
    message2.type = MessageType.Image
    message2.imageUrl = $r('app.media.foreground')

    const message3 = new ChatMessage(3)
    message3.text = 'Hello, SelectableMenu：https://github.com/iHongRen/SelectableMenu'

    const message4 = new ChatMessage(4)
    message4.text = `          登太白楼醉书
危楼接汉倚云端，飞檐欲触斗牛寒。
我来携酒凌层巅，长风万里送征鞍。
苍冥浩渺浮元气，大江奔涌走狂澜。
吴楚烟霞开画障，齐鲁青峦列翠屏。
手抚栏杆邀明月，明月笑我醉颜酡。
谪仙何处寻踪迹？唯有诗魂绕此阁。
忆昔长安金銮殿，曾奉新词动御筵。
沉香亭北花如锦，兴庆池边柳似绵。
力士脱靴羞权贵，贵妃研墨媚君前。
一朝谤起离京阙，扁舟载酒下江天。
采石矶头捞夜月，绿萝溪畔枕云眠。
兴来落笔摇五岳，诗成笑傲凌九天。
我今踏迹追先哲，胸中有气吞河山。
豪饮千觞心未醉，狂歌一曲意难阑。
浮云蔽日何须叹，世事如棋莫久看。
且放白鹿青崖间，漫随鸥鸟狎清川。
醉里不知天地阔，醒来犹见斗牛悬。
墨痕洒处风雷动，笔底龙蛇走蜿蜒。
人生得意须尽欢，莫使金樽空对月。
他年若遂凌云志，再驾长风访列仙。
银河为砚天为纸，写尽人间万古篇。
此楼此景长相忆，醉卧烟霞不知还。`

    this.messages.push(message1)
    this.messages.push(message2)
    this.messages.push(message3)
    this.messages.push(message4)
  }

  build() {
    Navigation() {
      List({ space: 12 }) {
        ForEach(this.messages, (message: ChatMessage) => {
          ListItem() {
            if (message.type === MessageType.Text) {
              // 文本消息
              Column() {
                SelectableText({
                  model: message,
                  // text: message.text,
                  fontSize: 16,
                  fontColor: '#333333',
                  caretColor: '#007AFF',
                  selectedBackgroundColor: '#33007AFF',
                  enableDataDetector: true
                }) {
                  Span(message.text) //SelectableText子组件与Text的子组件一致
                }
              }
              .backgroundColor('#ffffff')
              .borderRadius(12)
              .padding(16)
              .alignItems(HorizontalAlign.Start)

            } else if (message.type === MessageType.Image) {
              // 图片消息
              MenuContainer({
                model: message,

              }) {
                Image(message.imageUrl)
                  .width(150)
              }
            }
          }

        }, (message: ChatMessage) => message.id.toString())
      }
      .backgroundColor('#f5f5f5')
      .padding(15)
      .layoutWeight(1)
    }
    .title('聊天消息')
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
```



## API 参考

### SelectableText

可选择文本组件，继承Text组件大部分属性并扩展文本选择功能，增加属性如下：

| 属性           | 类型            | 默认值        | 说明           |
| -------------- | --------------- | ------------- | -------------- |
| model          | SelectableModel | -             | 数据模型实例   |
| popupColor     | ResourceColor   | '#e6000000'   | 弹出菜单背景色 |
| popupRadius    | number          | 5             | 弹出菜单圆角   |
| placement      | Placement       | Placement.Top | 弹出菜单位置   |
| menuItemWidth  | number          | 50 (vp)       | 菜单项的宽度   |
| maxColumnCount | number          | 5             | 最大的显示列数 |

### MenuContainer

菜单容器组件，适用于**非文本选择**的组件，菜单配置属性同上。

### SelectableModel

数据模型基类，提供选择状态管理和事件回调。

| 属性           | 类型                                              | 默认值 | 说明                                                         |
| -------------- | ------------------------------------------------- | ------ | ------------------------------------------------------------ |
| addOnPageTapListener(listener)    | (event?: BaseGestureEvent) => void                | -      | 添加页面点击监听                                             |
| removeOnPageTapListener(listener) | (event?: BaseGestureEvent) => void                | -      | 移除页面点击监听                                             |
| onPageTap                         | (event?: BaseGestureEvent) => void                | -      | 页面点击时通知所有监听器，触发菜单隐藏逻辑                  |
| selectionStart | number                                            | -1     | 选择的起始位置                                               |
| selectionEnd   | number                                            | -1     | 选择的结束位置                                               |
| longpressPopup | boolean                                           | false  | 非文本组件长按弹窗是否显示                                   |
| onDidMenuItem  | (isCopy?: boolean, isSelectAll?: boolean) => void | -      | 菜单项点击时，需调用这个方法。isCopy 是否是复制项点击，isSelectAll 是否是全选点击 |

需要继承实现的方法：

| 方法       | 返回值               | 说明             |
| ---------- | -------------------- | ---------------- |
| canCopy()  | boolean              | 是否可复制       |
| copyText() | string               | 返回可复制的文本 |
| getMenus() | SelectableMenuItem[] | 返回菜单项数组   |

### SelectableConfig

`SelectableModel` 的配置子类，支持通过**回调配置**而非继承使用。适合已有数据类不想或不能继承 `SelectableModel` 的场景。

| 属性                  | 类型                                                              | 默认值 | 说明                                         |
| --------------------- | ----------------------------------------------------------------- | ------ | -------------------------------------------- |
| canCopyCallback       | () => boolean                                                     | -      | 消息是否可复制的回调，未设置时返回 `false`   |
| copyTextCallback      | () => string                                                      | -      | 返回可复制文本的回调，未设置时返回 `''`      |
| getMenusCallback      | (selectionStart: number, selectionEnd: number) => SelectableMenuItem[] | -      | 返回菜单项数组的回调，接收当前选择范围参数 |

**组合模式示例：**

```typescript
import {
  MenuContainer, SelectableMenuItem, SelectableConfig, SelectableText
} from '@cxy/selecteablemenu'

enum MessageType {
  Text = 0,
  Image = 1
}

// 数据类无需继承 SelectableModel
@Observed
class ChatMessage {
  id: number = 0
  type: MessageType = MessageType.Text
  text: string = ''
  imageUrl: ResourceStr = ''
  config?: SelectableConfig // 通过组合持有配置实例
}

@Entry
@Component
struct Index {
  @State messages: Array<ChatMessage> = []

  aboutToAppear(): void {
    this.initMessages()
  }

  initMessages() {
    const message1 = new ChatMessage()
    message1.id = 1
    message1.text = '这是一条可以长按选择的文本消息'
    message1.config = new SelectableConfig()
    message1.config.canCopyCallback = () => message1.type === MessageType.Text && message1.text.length > 0
    message1.config.copyTextCallback = () => message1.text
    message1.config.getMenusCallback = (selectionStart: number, selectionEnd: number) => {
      const menus: SelectableMenuItem[] = []
      if (message1.type === MessageType.Text) {
        menus.push({
          title: '复制',
          icon: $r("app.media.copy"),
          action: () => {
            // 复制文本到剪贴板
            message1.config?.onDidMenuItem?.(true)
          }
        })
      }
      if (selectionStart >= 0 && selectionEnd > 0 &&
        selectionEnd - selectionStart < message1.text.length) {
        menus.push({
          title: '全选',
          icon: $r("app.media.edit"),
          action: () => {
            message1.config?.onDidMenuItem?.(false, true)
          }
        })
      }
      menus.push({
        title: '转发',
        icon: $r("app.media.forward"),
        action: () => {
          message1.config?.onDidMenuItem?.()
        }
      })
      return menus
    }

    this.messages.push(message1)
  }

  build() {
    Navigation() {
      List({ space: 12 }) {
        ForEach(this.messages, (message: ChatMessage) => {
          ListItem() {
            if (message.type === MessageType.Text) {
              Column() {
                SelectableText({
                  model: message.config!, // 传入 config 实例
                  fontSize: 16,
                  fontColor: '#333333',
                }) {
                  Span(message.text)
                }
              }
            }
          }
        }, (message: ChatMessage) => message.id.toString())
      }
      .parallelGesture(
        TapGesture()
          .onAction((event) => {
            SelectableModel.onPageTap(event)
          })
      )
    }
  }
}
```

**何时选择继承 vs 组合：**

| 模式 | 适用场景 |
|------|----------|
| 继承 `SelectableModel` | 新建数据类，代码简洁，可直接在类中访问 `this` |
| 组合 `SelectableConfig` | 已有数据类不能继承，或需要与多个模型类共存 |

## 破坏性变更

### v1.0.2 → v1.0.3：`onPageTap` API 变更

`onPageTap` 从**可赋值的单回调属性**变更为**多监听器模式**：

| 旧 API | 新 API | 说明 |
|--------|--------|------|
| `SelectableModel.onPageTap = handler` | `SelectableModel.addOnPageTapListener(handler)` | 注册监听器 |
| `SelectableModel.onPageTap = undefined` | `SelectableModel.removeOnPageTapListener(handler)` | 移除监听器 |
| `SelectableModel.onPageTap?.(event)` | `SelectableModel.onPageTap(event)` | 触发通知 |

旧的单回调模式在多个 `SelectableText` 实例同时存在时会互相覆盖，新模式通过 `Set` 支持多个监听器独立注册与注销，解决了此问题。

# 作者

[@仙银](https://github.com/iHongRen)
鸿蒙开源作品，欢迎持续关注 [🌟Star](https://github.com/iHongRen/RefreshList) ，[💖赞助](https://ihongren.github.io/donate.html)

1、[hpack](https://github.com/iHongRen/hpack) - 鸿蒙 HarmonyOS 一键打包上传分发测试工具。

2、[Open-in-DevEco-Studio](https://github.com/iHongRen/Open-in-DevEco-Studio)  - macOS 直接在 Finder 工具栏上，使用 DevEco-Studio 打开鸿蒙工程。

3、[cxy-theme](https://github.com/iHongRen/cxy-theme) - DevEco-Studio 绿色护眼背景主题

4、[harmony-udid-tool](https://github.com/iHongRen/harmony-udid-tool) - 简单易用的 HarmonyOS 设备 UDID 获取工具，适用于非开发人员。

5、[SandboxFinder](https://github.com/iHongRen/SandboxFinder) - 鸿蒙沙箱文件浏览器，支持模拟器和真机

6、[WebServer](https://github.com/iHongRen/WebServer) - 鸿蒙轻量级Web服务器框架，类 Express.js API 风格。

7、[SelectableMenu](https://github.com/iHongRen/SelectableMenu) - 适用于聊天对话框中的文本选择菜单

8、[RefreshList](https://github.com/iHongRen/RefreshList) - 功能完善的上拉下拉加载组件，支持各种自定义。https://ihongren.github.io/donate.html)
