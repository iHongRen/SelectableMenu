# SelectableMenu - 鸿蒙文本选择菜单组件

![GitHub release](https://img.shields.io/github/v/release/iHongRen/SelectableMenu) ![License](https://img.shields.io/badge/License-Apache%202.0-green.svg) 

鸿蒙文本选择菜单组件，用于聊天对话框中的长按文本选择与操作。



<img src="https://7up.pics/images/2026/05/28/demo.gif" width=320>

## 功能特性

- **文本选择** — 长按自动全选，支持手动调整选择范围
- **自定义菜单** — 菜单项支持图标、标题和操作回调
- **非文本组件支持** — `MenuContainer` 适配图片等非文本场景
- **两种使用模式** — 继承模式（`SelectableModel`）与组合模式（`SelectableConfig`）
- **多实例安全** — 基于 `Set` 的多监听器模式，避免回调互相覆盖

## 安装

```bash
ohpm install @cxy/selecteablemenu
```

或在 `oh-package.json5` 中添加依赖后同步项目：

```json
{
  "dependencies": {
    "@cxy/selecteablemenu": "^1.1.0"
  }
}
```

## 快速开始

> [查看完整 demo](https://github.com/iHongRen/SelectableMenu)

### 继承模式

数据类继承 `SelectableModel`，在类内直接访问 `this`，代码最简洁：

```typescript
import { MenuContainer, SelectableMenuItem, SelectableModel, SelectableText } from '@cxy/selecteablemenu'

@Observed
class ChatMessage extends SelectableModel {
  id: number = 0
  text: string = ''

  constructor(id: number) { super(); this.id = id }

  canCopy(): boolean { return this.text.length > 0 }
  copyText(): string { return this.text }

  getMenus(): SelectableMenuItem[] {
    const menus: SelectableMenuItem[] = []
    if (this.canCopy()) {
      menus.push({ title: '复制', icon: $r("app.media.copy"), action: () => this.onDidMenuItem?.(true) })
      if (this.selectionStart >= 0 && this.selectionEnd - this.selectionStart < this.copyText().length) {
        menus.push({ title: '全选', icon: $r("app.media.edit"), action: () => this.onDidMenuItem?.(false, true) })
      }
    }
    menus.push({ title: '转发', icon: $r("app.media.forward"), action: () => this.onDidMenuItem?.() })
    return menus
  }
}
```

使用：

```typescript
SelectableText({ model: message, fontSize: 16, fontColor: '#333333' }) {
  Span(message.text)
}
```

### 组合模式

已有数据类无法继承时，通过 `SelectableConfig` 以回调方式配置：

```typescript
import { MenuContainer, SelectableMenuItem, SelectableConfig, SelectableText } from '@cxy/selecteablemenu'

@Observed
class ChatMessage {
  id: number = 0
  text: string = ''
  config?: SelectableConfig // 组合持有配置实例
}

// 初始化时设置回调
const msg = new ChatMessage()
msg.text = '这是一条消息'
msg.config = new SelectableConfig()
msg.config.canCopyCallback = () => msg.text.length > 0
msg.config.copyTextCallback = () => msg.text
msg.config.getMenusCallback = (start, end) => {
  const menus: SelectableMenuItem[] = []
  menus.push({ title: '复制', icon: $r("app.media.copy"), action: () => msg.config?.onDidMenuItem?.(true) })
  return menus
}
```

使用：

```typescript
SelectableText({ model: message.config!, fontSize: 16, fontColor: '#333333' }) {
  Span(message.text)
}
```

### 模式选择

| 模式 | 适用场景 |
|------|----------|
| 继承 `SelectableModel` | 新建数据类，代码简洁，可直接在类中访问 `this` |
| 组合 `SelectableConfig` | 已有数据类不能继承，或需要与多个模型类共存 |

## API 参考

### SelectableText

可选择文本组件，继承 `Text` 组件大部分属性并扩展文本选择功能。新增属性：

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| model | `SelectableModel` | - | 数据模型实例 |
| popupColor | `ResourceColor` | `'#e6000000'` | 弹出菜单背景色 |
| popupRadius | `number` | `5` | 弹出菜单圆角 |
| placement | `Placement` | `Placement.Top` | 弹出菜单位置 |
| menuItemWidth | `number` | `50` (vp) | 菜单项宽度 |
| maxColumnCount | `number` | `5` | 最大显示列数 |

子组件与 `Text` 一致，支持 `Span`、`ImageSpan`、`SymbolSpan`、`ContainerSpan`。

### MenuContainer

菜单容器组件，适用于**非文本选择**场景（如图片长按弹菜单），配置属性同 `SelectableText`。

```typescript
MenuContainer({ model: message }) {
  Image(message.imageUrl).width(150)
}
```

### SelectableModel

数据模型基类，提供选择状态管理和事件回调。

**属性：**

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| selectionStart | `number` | `-1` | 选择起始位置 |
| selectionEnd | `number` | `-1` | 选择结束位置 |
| longpressPopup | `boolean` | `false` | 非文本组件长按弹窗是否显示 |
| onDidMenuItem | `(isCopy?, isSelectAll?) => void` | - | 菜单项点击回调 |

**静态方法：**

| 方法 | 说明 |
|------|------|
| `addOnPageTapListener(listener)` | 注册页面点击监听 |
| `removeOnPageTapListener(listener)` | 移除页面点击监听 |
| `onPageTap(event)` | 通知所有监听器，触发菜单隐藏 |

**需子类覆盖：**

| 方法 | 返回值 | 说明 |
|------|--------|------|
| `canCopy()` | `boolean` | 是否可复制 |
| `copyText()` | `string` | 可复制的文本 |
| `getMenus()` | `SelectableMenuItem[]` | 菜单项数组 |

### SelectableConfig

`SelectableModel` 的配置子类，通过回调配置而非继承。适合已有数据类不想或不能继承的场景。

| 属性 | 类型 | 说明 |
|------|------|------|
| canCopyCallback | `() => boolean` | 消息是否可复制，未设置返回 `false` |
| copyTextCallback | `() => string` | 可复制文本，未设置返回 `''` |
| getMenusCallback | `(start, end) => SelectableMenuItem[]` | 返回菜单项，接收当前选择范围 |

### SelectableMenuItem

| 属性 | 类型 | 说明 |
|------|------|------|
| title | `string` | 菜单项标题 |
| icon | `ResourceStr` | 菜单项图标 |
| action | `() => void` | 点击回调 |


## 作者

[@仙银](https://github.com/iHongRen) 鸿蒙开源作品，欢迎持续关注

1、[hpack](https://github.com/iHongRen/hpack) - 鸿蒙 HarmonyOS 一键打包上传分发测试工具

2、[Open-in-DevEco-Studio](https://github.com/iHongRen/Open-in-DevEco-Studio)  - macOS  Finder 工具栏 app，使用 DevEco-Studio 打开鸿蒙工程

3、[cxy-theme](https://github.com/iHongRen/cxy-theme) - DevEco-Studio 绿色护眼背景主题

4、[harmony-udid-tool](https://github.com/iHongRen/harmony-udid-tool) - 简单易用的 HarmonyOS 设备 UDID 获取工具，适用于非开发人员

5、[SandboxFinder](https://github.com/iHongRen/SandboxFinder) - 鸿蒙沙箱文件浏览器，支持模拟器和真机

6、[WebServer](https://github.com/iHongRen/WebServer) - 鸿蒙轻量级Web服务器框架，类 Express.js API 风格

7、[SelectableMenu](https://github.com/iHongRen/SelectableMenu) - 适用于聊天对话框中的文本选择菜单

8、[RefreshList](https://github.com/iHongRen/RefreshList) - 功能完善的上拉下拉加载组件，支持各种自定义

9、[hm-app-check-tool](https://github.com/iHongRen/hm-app-check-tool) - macOS 鸿蒙扫描工具，扫描HAP、HSP、App包内容并输出检测结果报告

10、[hm-find-unused-res-tool](https://github.com/iHongRen/hm-find-unused-res-tool) - 鸿蒙无用资源清理工具，一个有UI的 Python 脚本

11、[harmony-study-demo](https://github.com/iHongRen/harmony-study-demo) - HarmonyOS 应用开发学习项目，包含了多个实用的功能示例