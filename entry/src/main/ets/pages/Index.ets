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
          SelectableModel.onPageTap?.(event)
        })
    )
  }
}