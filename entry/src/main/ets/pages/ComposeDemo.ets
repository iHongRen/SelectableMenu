import {
  MenuContainer, SelectableMenuItem, SelectableConfig, SelectableText
} from '@cxy/selecteablemenu'

enum MessageType {
  Text = 0,
  Image = 1
}

@Observed
class ChatMessage2 {
  id: number = 0
  type: MessageType = MessageType.Text
  text: string = ''
  imageUrl: ResourceStr = ''
  config?: SelectableConfig
}

@Component
export struct ComposeDemo {
  @State messages: Array<ChatMessage2> = []

  aboutToAppear(): void {
    this.initMessages()
  }

  createConfig(msg: ChatMessage2): SelectableConfig {
    const config = new SelectableConfig()
    config.canCopyCallback = () => msg.type === MessageType.Text && msg.text.length > 0
    config.copyTextCallback = () => msg.text
    config.getMenusCallback = (selectionStart: number, selectionEnd: number) => {
      const menus: SelectableMenuItem[] = []
      if (msg.type === MessageType.Text) {
        menus.push({
          title: '复制',
          icon: $r("app.media.copy"),
          action: () => {
            msg.config?.onDidMenuItem?.(true)
          }
        })
      }
      if (selectionStart >= 0 && selectionEnd > 0 &&
        selectionEnd - selectionStart < msg.text.length) {
        menus.push({
          title: '全选',
          icon: $r("app.media.edit"),
          action: () => {
            msg.config?.onDidMenuItem?.(false, true)
          }
        })
      }
      menus.push({
        title: '转发',
        icon: $r("app.media.forward"),
        action: () => {
          msg.config?.onDidMenuItem?.()
        }
      })
      return menus
    }
    return config
  }

  initMessages() {
    const texts = [
      '这是一条可以长按选择的文本消息',
      'Hello, SelectableMenu：https://github.com/iHongRen/SelectableMenu',
      '今天天气不错，适合出去走走',
      '你说什么呢？我听不太清楚，可以再说一遍吗？',
      '晚上一起吃饭吗？',
      '好的，明天见！',
      '收到，谢谢！',
      '哈哈哈哈太有趣了'
    ]

    const longText = `登太白楼醉书
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

    let id = 1
    for (const text of texts) {
      const msg = new ChatMessage2()
      msg.id = id++
      msg.text = text
      msg.config = this.createConfig(msg)
      this.messages.push(msg)
    }

    const img1 = new ChatMessage2()
    img1.id = id++
    img1.type = MessageType.Image
    img1.imageUrl = $r('app.media.foreground')
    img1.config = this.createConfig(img1)
    this.messages.push(img1)

    const longMsg = new ChatMessage2()
    longMsg.id = id++
    longMsg.text = longText
    longMsg.config = this.createConfig(longMsg)
    this.messages.push(longMsg)

    const img2 = new ChatMessage2()
    img2.id = id++
    img2.type = MessageType.Image
    img2.imageUrl = $r('app.media.foreground')
    img2.config = this.createConfig(img2)
    this.messages.push(img2)
  }

  build() {
    List({ space: 12 }) {
      ForEach(this.messages, (message: ChatMessage2) => {
        ListItem() {
          if (message.type === MessageType.Text) {
            Column() {
              SelectableText({
                model: message.config!,
                fontSize: 16,
                fontColor: '#333333',
                caretColor: '#007AFF',
                selectedBackgroundColor: '#33007AFF',
                enableDataDetector: true
              }) {
                Span(message.text)
              }
            }
            .backgroundColor('#ffffff')
            .borderRadius(12)
            .padding(16)
            .alignItems(HorizontalAlign.Start)
          } else if (message.type === MessageType.Image) {
            MenuContainer({ model: message.config! }) {
              Image(message.imageUrl)
                .width(150)
            }
          }
        }
      }, (message: ChatMessage2) => message.id.toString())
    }
    .backgroundColor('#f5f5f5')
    .padding(15)
    .layoutWeight(1)
  }
}