
![](Image/logo.png)

[![Version](https://img.shields.io/cocoapods/v/SwiftShow.svg?style=flat)](http://cocoapods.org/pods/SwiftShow)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 11.0+](https://img.shields.io/badge/Xcode-11.0%2B-blue.svg)
![iOS 11.0+](https://img.shields.io/badge/iOS-11.0%2B-blue.svg)
![Swift 4.2+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

各种弹出窗口，主要包含Toast，Loading，Alert等HUD，以及各个方向的弹出式窗口。

用法详见demo。

## 安装

### CocoaPods

1. 在 Podfile 中添加 `pod 'SwiftShow'`
2. 执行 `pod install` 或 `pod update`
3. 导入 `import SwiftShow`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftShow 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Package Dependency`，然后在搜索栏输入

`https://github.com/zjinhu/SwiftShow`，即可完成集成

### 手动集成

SwiftShow 也支持手动集成，只需把 Sources 文件夹中的 SwiftShow 文件夹拖进需要集成的项目即可

## 使用

基本弹窗 API 全部都在 `Show.swift`，其中包括多个种类

### 1. Toast

|                       |                       |                       |
| --------------------- | --------------------- | --------------------- |
| ![](Image/toast1.png) | ![](Image/toast2.png) | ![](Image/toast3.png) |
| ![](Image/toast4.png) | ![](Image/toast5.png) |                       |

#### 配置项

```swift
public class ShowToastConfig {
    public var animateDuration = 0.5        // 执行动画时间 默认0.5
    public var showTime: Double = 3.0       // Toast默认停留时间 默认3秒
    public var maxWidth: Float = 200        // Toast最大宽度 默认200
    public var maxHeight: Float = 500       // Toast最大高度 默认500
    public var cornerRadius: CGFloat = 5    // Toast圆角 默认5
    public var bgColor: UIColor             // Toast背景颜色 默认黑色
    public var shadowColor: CGColor         // 阴影颜色 默认clear
    public var shadowOpacity: Float = 0.5   // 阴影Opacity 默认0.5
    public var shadowRadius: CGFloat = 5    // 阴影Radius 默认5
    public var imageType: ImageLayoutType   // Toast图文混排样式 默认图片在左
    public var padding: Float = 10          // Toast背景与内容之间的内边距 默认10
    public var offSet: Float = 100          // Toast在屏幕的位置（左右居中调节上下）默认100
    public var offSetType: ToastOffset      // Toast在屏幕的位置 默认中间
    public var titleColor: UIColor          // Toast title文字字体颜色 默认白色
    public var titleFont: UIFont            // Toast title字体 默认15
    public var subTitleColor: UIColor       // Toast subTitle文字字体颜色 默认浅灰色
    public var subTitleFont: UIFont         // Toast subTitle字体 默认12
    public var spaceImage: CGFloat = 5      // Toast图文间距 默认5
    public var spaceText: CGFloat = 5       // Toast文本间距 默认5
}
```

#### API

```swift
/// 展示toast
/// - Parameters:
///   - title: 标题文本
///   - subTitle: 副标题文本（可选）
///   - image: 图片（可选）
///   - config: toast配置回调，不传为默认
Show.toast("成功", subTitle: "操作已完成", image: UIImage(named: "check")) { config in
    config.showTime = 2.0
    config.offSetType = .top
    config.offSet = 80
}
```

### 2. Loading

| ![](Image/Loading1.png) | ![](Image/Loading2.png) | ![](Image/Loading3.png) |
| ----------------------- | ----------------------- | ----------------------- |
| 默认样式                | 可图文                  | 可添加阴影，遮罩        |

#### 配置项

```swift
public class ShowLoadingConfig {
    public var maxWidth: Float = 200          // loading最大宽度 默认200
    public var maxHeight: Float = 200         // loading最大高度 默认200
    public var cornerRadius: CGFloat = 5      // 圆角大小 默认5
    public var titleFont: UIFont              // 文字字体大小 默认系统字体15
    public var titleColor: UIColor            // 文字字体颜色 默认白色
    public var subTitleFont: UIFont           // 副标题字体 默认系统字体12
    public var subTitleColor: UIColor         // 副标题文字颜色 默认浅灰色
    public var enableEvent: Bool = false      // 是否背景透传点击 默认false
    public var effectStyle                    // 背景蒙版 毛玻璃
    public var tintColor: UIColor             // 加载框主体颜色 默认黑色
    public var bgColor: UIColor               // 背景颜色 默认clear
    public var maskType: MaskType             // 默认蒙版类型 背景色
    public var imagesArray: [UIImage]?        // 图片动画类型 所需要的图片数组
    public var activityColor: UIColor         // 菊花颜色 不传递图片数组的时候默认使用菊花
    public var animationTime: Double = 1.0    // 图片动画时间 默认1.0
    public var imageType: ImageLayoutType     // loading图文混排样式 默认图片在上
    public var verticalPadding: Float = 20    // loading背景与内容之间的上下边距 默认20
    public var horizontalPadding: Float = 20  // loading背景与内容之间的左右边距 默认20
    public var spaceImage: CGFloat = 5        // loading文字与图片之间的间距 默认5
    public var spaceText: CGFloat = 5         // loading文本间距 默认5
}
```

#### API

```swift
/// 在当前VC中展示loading
Show.loading("加载中", subTitle: "请稍候...")

/// 在window中展示loading
Show.loadingOnWindow("加载中...")

/// 在指定view中添加loading
Show.loadingOnView(myView, title: "加载中...")

/// 手动隐藏上层VC中的loading
Show.hideLoading()

/// 手动隐藏window中loading
Show.hideLoadingOnWindow()

/// 手动隐藏指定view中loading
Show.hideLoadingOnView(myView)
```

### 3. Alert

| ![](Image/Alert1.png) | ![](Image/Alert2.png) | ![](Image/Alert3.png) |
| --------------------- | --------------------- | --------------------- |
| 默认弹窗              | 可修改弹窗遮罩、阴影  | 可使用富文本          |

#### 配置项

```swift
public class ShowAlertConfig {
    public var animateDuration = 0.5       // 执行动画时间 默认0.5
    public var effectStyle                 // 背景蒙版 毛玻璃
    public var width: Float = 280          // alert宽度 默认280
    public var maxHeight: Float = 500      // alert最大高度 默认500
    public var buttonHeight: Float = 50    // alert按钮高度 默认50
    public var cornerRadius: CGFloat = 5   // alert圆角 默认5
    public var space: Float = 5            // alert图文间距 默认5
    public var tintColor: UIColor          // alert主体颜色 默认白色
    public var bgColor: UIColor            // alert背景颜色 默认黑色半透明
    public var lineColor: UIColor          // alert分割线颜色 默认浅灰色
    public var maskType: MaskType          // 默认蒙版类型 颜色
    public var titleFont: UIFont           // alert标题字体 默认系统21
    public var titleColor: UIColor         // alert标题字体颜色 默认文本颜色
    public var textFont: UIFont            // alert信息字体 默认系统14
    public var textColor: UIColor          // alert信息字体颜色 默认文本颜色
    public var buttonFont: UIFont          // alert按钮字体 默认系统15
    public var leftColor: UIColor          // alert左侧按钮字体颜色 默认文本颜色
    public var rightColor: UIColor         // alert右侧按钮字体颜色 默认文本颜色
    public var verticalPadding: Float = 10 // alert背景与内容之间的上下边距 默认10
    public var horizontalPadding: Float = 10 // alert背景与内容之间的左右边距 默认10
}
```

#### API

```swift
/// 默认样式Alert
Show.alert(title: "提示",
           message: "确定要执行此操作吗？",
           leftBtnTitle: "取消",
           rightBtnTitle: "确定",
           leftBlock: { print("已取消") },
           rightBlock: { print("已确认") })

/// 富文本样式Alert
Show.attributedAlert(attributedTitle: attributedTitle,
                     attributedMessage: attributedMessage,
                     leftBtnAttributedTitle: leftAttributed,
                     rightBtnAttributedTitle: rightAttributed,
                     leftBlock: { },
                     rightBlock: { })

/// 自定义Alert（支持图片、富文本、配置）
Show.customAlert(title: "标题",
                 image: UIImage(named: "icon"),
                 message: "信息内容",
                 leftBtnTitle: "取消",
                 rightBtnTitle: "确定",
                 leftBlock: { },
                 rightBlock: { }) { config in
    config.tintColor = .systemBlue
    config.cornerRadius = 12
}

/// 手动隐藏Alert
Show.hideAlert()
```

### 4. PopView

| ![](Image/Pop1.gif) | ![](Image/Pop2.gif) |
| ------------------- | ------------------- |

#### 配置项

```swift
public class ShowPopViewConfig {
    public var effectStyle                // 背景蒙版 毛玻璃
    public var clickOutHidden = true      // 点击其他地方是否消失 默认yes
    public var maskType: MaskType         // 默认蒙版类型 颜色
    public var bgColor: UIColor           // 背景颜色 默认黑色半透明
    public var animateDuration = 0.3      // 执行动画时间 默认0.3
    public var animateDamping = true      // 动画是否使用弹性 默认true
    public var isAnimate = true           // 是否使用动画 默认true
    public var showAnimateType: PopViewShowType? = .center // 弹出视图样式位置 默认中心
}
```

#### API

```swift
/// 弹出view
/// - Parameters:
///   - contentView: 被弹出的View
///   - config: popview配置
///   - showClosure: 弹出回调
///   - hideClosure: 收起回调
Show.pop(myContentView) { config in
    config.showAnimateType = .bottom
    config.animateDamping = true
} showClosure: {
    print("弹出完成")
} hideClosure: {
    print("收起完成")
}

/// 手动收起popview
Show.hidePop {
    print("已收起")
}
```

### 5. DropDown

![](Image/DropDown.gif)

#### 配置项

```swift
public class ShowDropDownConfig {
    public var effectStyle                // 背景蒙版 毛玻璃
    public var clickOutHidden = true      // 点击其他地方是否消失 默认yes
    public var maskType: MaskType         // 默认蒙版类型 颜色
    public var bgColor: UIColor           // 背景颜色 默认黑色半透明
    public var animateDuration = 0.3      // 执行动画时间 默认0.3
    public var animateDamping = true      // 动画是否使用弹性 默认true
    public var isAnimate = true           // 是否使用动画 默认true
    public var fromY: CGFloat = 88        // 弹出视图起始Y位置 默认88
}
```

#### API

```swift
/// 从NavBar或VC的view中弹出下拉视图,可以盖住Tabbar
/// - Parameters:
///   - contentView: 被弹出的view
///   - config: 配置回调
///   - showClosure: 展示回调
///   - hideClosure: 隐藏回调
///   - willShowClosure: 即将展示回调
///   - willHideClosure: 即将收起回调
Show.coverTabbar(myContentView) { config in
    config.fromY = 100
} showClosure: {
    print("展示完成")
} hideClosure: {
    print("隐藏完成")
} willShowClosure: {
    print("即将展示")
} willHideClosure: {
    print("即将隐藏")
}

/// 当前是否正在展示DropDown
let isVisible = Show.isHaveCoverTabbarView()

/// 手动隐藏DropDown
Show.hideCoverTabbar {
    print("已隐藏")
}
```

### 6. 通用工具

```swift
/// 获取顶层VC
let topVC = Show.currentViewController()
```

---

## AI Skills 使用教程

SwiftShow 提供了专门的 AI Skills 文件，帮助 AI 编程助手快速理解和使用此库。

### 什么是 Skills 文件？

`.ai/skills/swiftshow.md` 文件包含了完整的 API 参考、配置选项和使用模式，专门为 AI 助手设计。

### AI 如何使用 Skills 文件

在使用 SwiftShow 的 iOS 项目中，AI 编程助手会：

1. **自动发现** `.ai/skills/` 目录下的 Skills 文件
2. **参考** API 签名和配置选项
3. **生成** 正确的 SwiftShow 代码

### 示例 AI 提示词

使用 AI 编程助手时，可以使用如下提示：

```
在获取数据时添加 loading 提示
```

AI 会读取 Skills 文件并生成：

```swift
Show.loading("加载中", subTitle: "正在获取数据...")
// ... 你的异步代码 ...
Show.hideLoading()
```

```
保存成功后显示成功 toast
```

AI 会生成：

```swift
Show.toast("成功", subTitle: "数据已保存", image: UIImage(systemName: "checkmark.circle.fill"))
```

```
删除前显示确认弹窗
```

AI 会生成：

```swift
Show.alert(title: "删除确认",
           message: "确定要删除此项吗？",
           leftBtnTitle: "取消",
           rightBtnTitle: "删除",
           rightBlock: { 
               // 删除操作
           })
```

### Skills 文件位置

```
.ai/skills/swiftshow.md
```

该文件会被 AI 编程助手自动发现并读取，提供：
- 完整的 API 参考和方法签名
- 所有配置属性及默认值
- 常用使用模式和示例
- 各组件类型的最佳实践
