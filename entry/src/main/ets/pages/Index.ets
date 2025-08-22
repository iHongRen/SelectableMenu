import { SelectableMenuItem, SelectableModel, SelectableText } from '@cxy/selecteablemenu'

@Observed
class MyItem extends SelectableModel {
  id: number = 0
  text: string = ''
  img: string = ''

  public canCopy() {
    return this.text.length > 0
  }

  public copyText(): string {
    return this.text
  }

  public getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []

    if (this.canCopy()) {
      menus.push({
        title: '复制',
        icon: $r("app.media.copy"),
        action: () => {
          // ChatMsgEmitter.emit(ChatMsgEventName.Copy, msg)
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

          // ChatMsgEmitter.emit(ChatMsgEventName.SelectAll, msg)
          // msg.onMenuItemClick?.(ChatMsgEventName.SelectAll)
        }
      })
    }

    menus.push({
      title: '转发',
      icon: $r("app.media.forward"),
      action: () => {
        this.onMenuItemClick?.()
      }
    })
    menus.push({
      title: '收藏',
      icon: $r("app.media.favor"),
      action: () => {
        this.onMenuItemClick?.()
      }
    })

    menus.push({
      title: '删除',
      icon: $r("app.media.delete"),
      action: () => {
        this.onMenuItemClick?.()
      }
    })

    menus.push({
      title: '多选',
      icon: $r("app.media.sort"),
      action: () => {
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

  aboutToAppear(): void {
    const item1 = new MyItem()
    item1.id = 1
    item1.text = '得到答复额外惹我热武器热气温热温热我饿武器扔垃圾；了'

    const item2 = new MyItem()
    item1.id = 2
    item2.text = '大师傅额外企鹅企鹅万福范德萨范德萨甲方客户端洒基开发和解答凯撒了哈饭卡打撒达说法打撒放大时范德萨范德萨'

    this.list.push(item1)
    this.list.push(item2)
  }

  build() {
    Column() {
      List() {
        ForEach(this.list, (item: MyItem) => {
          ListItem() {
            SelectableText({
              model: item
            }) {
              Span(item.text)
                .fontSize(15)
                .fontColor('#33')
            }
          }
          .padding(15)
        }, (item: MyItem) => (item.id).toString())
      }
    }
    .layoutWeight(1)
    .padding({ top: 80, bottom: 30 })
    .parallelGesture(
      TapGesture()
        .onAction((event) => {
          SelectableModel.onPageTap?.(event)
        })
    )
  }
}