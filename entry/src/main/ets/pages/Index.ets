import { SelectableMenuItem, SelectableModel, SelectableText } from '@cxy/selecteablemenu'

enum MsgType {
  Text = 0,
  Image = 1,
  Video = 2,
  //... 其他
}

@Observed
class MyItem extends SelectableModel {
  id: number = 0
  type: MsgType = MsgType.Text
  text: string = ''
  img: ResourceStr = ''

  // 覆盖父类方法
  public canCopy() {
    return this.text.length > 0
  }

  // 覆盖父类方法
  public copyText(): string {
    return this.text
  }

  // 覆盖父类方法
  public getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []

    if (this.canCopy()) {
      menus.push({
        title: '复制',
        icon: $r("app.media.copy"),
        action: () => {
          // TODO： 处理复制逻辑
          // const text = this.copyText()
          // ...
          this.onMenuItemClick?.(false, 50)
        }
      })
    }

    if (this.canCopy() && this.selectionStart >= 0 && this.selectionEnd > 0 &&
      this.selectionEnd - this.selectionStart < this.copyText().length) {
      menus.push({
        title: '全选',
        icon: $r("app.media.edit"),
        action: () => {
          this.onMenuItemClick?.(true, 50)
        }
      })
    }

    menus.push({
      title: '转发',
      icon: $r("app.media.forward"),
      action: () => {
        // TODO： 处理对应逻辑
        // ...
        this.onMenuItemClick?.()
      }
    })
    menus.push({
      title: '收藏',
      icon: $r("app.media.favor"),
      action: () => {
        // TODO： 处理对应逻辑
        // ...
        this.onMenuItemClick?.()
      }
    })

    menus.push({
      title: '删除',
      icon: $r("app.media.delete"),
      action: () => {
        // TODO： 处理对应逻辑
        // ...
        this.onMenuItemClick?.()
      }
    })

    menus.push({
      title: '多选',
      icon: $r("app.media.sort"),
      action: () => {
        // TODO： 处理对应逻辑
        // ...
        this.onMenuItemClick?.()
      }
    })

    return menus
  }
}


@Entry
@Component
struct Index {
  @State list: MyItem[] = []
  private pageStack: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.initData()
  }

  initData() {
    const item1 = new MyItem()
    item1.id = 1
    item1.text = '鸿蒙文本选择菜单，用于聊天消息文本选择复制'

    const item2 = new MyItem()
    item1.id = 2
    item2.text =
      '大师傅额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭答凯撒了哈饭卡打撒达说法打撒放大时范德萨范德萨'

    const item3 = new MyItem()
    item3.id = 3
    item3.type = MsgType.Image
    item3.img = $r('app.media.avatar')


    this.list.push(item1)
    this.list.push(item2)
    this.list.push(item3)
  }

  build() {
    Navigation(this.pageStack) {
      List() {
        ForEach(this.list, (item: MyItem) => {
          ListItem() {
            if (item.type === MsgType.Text) {
              Column() {
                SelectableText({
                  model: item
                }) {
                  Span(item.text)
                    .fontSize(15)
                    .fontColor('#33')
                }
              }
              .backgroundColor('#fff')
              .borderRadius(10)
              .padding(15)

            } else if (item.type === MsgType.Image) {
              Image(item.img)
                .width(200)
            }
          }
          .padding(15)
        }, (item: MyItem) => (item.id).toString())
      }
      .backgroundColor('#f0f0f0')
      .layoutWeight(1)
    }
    .title('文本选择菜单Demo')
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