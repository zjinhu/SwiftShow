//
//  Config.swift
//  SwiftShow
//
//  Created by iOS on 2020/4/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

/// Mask type for background / 背景遮罩类型
public enum MaskType {
    case color /// Color mask / 颜色遮罩
    case effect /// Blur effect mask / 毛玻璃遮罩
}

/// Toast offset position / Toast偏移位置
public enum ToastOffset {
    case top /// Top of screen / 屏幕顶部
    case center /// Center of screen / 屏幕中心
    case bottom /// Bottom of screen / 屏幕底部
}

/// Image layout type / 图片布局类型
public enum ImageLayoutType {
    /// Image on left, text on right / 按钮图片居左 文案居右
    case left
    /// Image on top, text on bottom / 按钮图片居上 文案居下
    case top
}

/// PopView show animation direction / PopView弹出方向
public enum PopViewShowType {
    case top /// From top / 从顶部
    case left /// From left / 从左侧
    case bottom /// From bottom / 从底部
    case right /// From right / 从右侧
    case center /// From center (zoom) / 从中心（缩放）
}

// MARK: - Toast Configuration / Toast配置
public class ShowToastConfig {
    /// Animation duration, default 0.5s / 执行动画时间 默认0.5
    public var animateDuration = 0.5
    /// Toast display duration, default 3.0s / Toast默认停留时间 默认3秒
    
    public var showTime : Double = 3.0
    
    
    /// Toast max width, default 200 / Toast最大宽度 默认200
    public var maxWidth : Float = 200
    /// Toast max height, default 500 / Toast最大高度 默认500
    public var maxHeight : Float = 500
    /// Toast corner radius, default 5 / Toast圆角 默认5
    public var cornerRadius : CGFloat = 5

    
    /// Toast background color, default black / Toast背景颜色 默认黑色
    public var bgColor : UIColor = .blackBGColor
    /// Shadow color, default clear / 阴影颜色 默认clearcolor
    public var shadowColor : CGColor = UIColor.clear.cgColor
    /// Shadow opacity, default 0.5 / 阴影Opacity 默认0.5
    public var shadowOpacity : Float = 0.5
    /// Shadow radius, default 5 / 阴影Radius 默认5
    public var shadowRadius : CGFloat = 5


    /// Toast image-text layout style, default image on left / Toast图文混排样式 默认图片在左
    public var imageType : ImageLayoutType = .left
    /// Padding between background and content, default 10 / Toast背景与内容之间的内边距 默认10
    public var padding : Float = 10
    /// Toast offset from center (top/bottom), default 100 / Toast 在屏幕的位置（左右居中调节上下）默认100
    public var offSet : Float = 100
    /// Toast position type on screen, default center / Toast 在屏幕的位置 默认中间
    public var offSetType : ToastOffset = .center
    
    
    /// Toast title text color, default white / Toast title文字字体颜色 默认白色
    public var titleColor : UIColor = .white
    /// Toast title font, default system 15 / Toast title字体 默认15
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// Toast subtitle text color, default light gray / Toast subTitle文字字体颜色 默认浅灰色
    public var subTitleColor : UIColor = .lightGray
    /// Toast subtitle font, default system 12 / Toast subTitle字体 默认12
    public var subTitleFont : UIFont = UIFont.systemFont(ofSize: 12)
    
    /// Toast image-text spacing, default 5 / Toast图文间距 默认5
    public var spaceImage : CGFloat = 5
    /// Toast text line spacing, default 5 / Toast 文本间距 默认5
    public var spaceText : CGFloat = 5
}

// MARK: - Loading Configuration / Loading配置
public class ShowLoadingConfig {
    /// Loading max width, default 200 / loading最大宽度 默认200
    public var maxWidth : Float = 200
    /// Loading max height, default 200 / loading最大高度 默认200
    public var maxHeight : Float = 200
    /// Corner radius, default 5 / 圆角大小 默认5
    public var cornerRadius : CGFloat = 5

    /// Title font, default system 15 / 文字字体大小 默认系统字体15
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// Title text color, default white / 文字字体颜色 默认白色
    public var titleColor : UIColor = .white
    /// Subtitle font, default system 12 / 副标题字体大小 默认系统字体12
    public var subTitleFont : UIFont = UIFont.systemFont(ofSize: 12)
    /// Subtitle text color, default light gray / 副标题文字字体颜色 默认浅灰色
    public var subTitleColor : UIColor = .lightGray
    
    
    /// Allow touch events through background, default false / 是否背景透传点击 默认false
    public var enableEvent: Bool = false
    /// Background blur effect / 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    /// Loading container color, default black / 加载框主体颜色 默认黑色
    public var tintColor : UIColor = .blackBGColor
    /// Background color, default clear / 背景颜色 默认clear
    public var bgColor : UIColor = .clear
    /// Default mask type, color / 默认蒙版类型 背景色
    public var maskType : MaskType = .color
    /// Shadow color, default clear / 阴影颜色 默认clearcolor
    public var shadowColor : CGColor = UIColor.clear.cgColor
    /// Shadow opacity, default 0.5 / 阴影Opacity 默认0.5
    public var shadowOpacity : Float = 0.5
    /// Shadow radius, default 5 / 阴影Radius 默认5
    public var shadowRadius : CGFloat = 5
    
    /// Image animation frames (array of images) / 图片动画类型 所需要的图片数组
    public var imagesArray : [UIImage]?
    /// Activity indicator color, used when no image array / 菊花颜色 不传递图片数组的时候默认使用菊花
    public var activityColor : UIColor = .white
    /// Image animation duration, default 1.0s / 图片动画时间 默认1.0
    public var animationTime : Double = 1.0
    /// Loading image-text layout style, default image on top / loading图文混排样式 默认图片在上
    public var imageType : ImageLayoutType = .top
    
    
    /// Loading vertical padding, default 20 / loading背景与内容之间的上下边距 默认20
    public var verticalPadding : Float = 20
    /// Loading horizontal padding, default 20 / loading背景与内容之间的左右边距 默认20
    public var horizontalPadding : Float = 20
    
    /// Loading image-text spacing, default 5 / loading文字与图片之间的间距 默认5
    public var spaceImage : CGFloat = 5
    /// Loading text line spacing, default 5 / loading 文本间距 默认5
    public var spaceText : CGFloat = 5
}
    
// MARK: - Alert Configuration / Alert配置
public class ShowAlertConfig {
    /// Animation duration, default 0.5s / 执行动画时间 默认0.5
    public var animateDuration = 0.5
    /// Background blur effect / 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light

    /// Alert width, default 280 / alert宽度 默认280
    public var width : Float = 280
    /// Alert max height, default 500 / alert最大高度 默认500
    public var maxHeight : Float = 500
    /// Alert button height, default 50 / alert按钮高度 默认50
    public var buttonHeight : Float = 50
    /// Alert corner radius, default 5 / alert圆角 默认5
    public var cornerRadius : CGFloat = 5
    /// Alert image-text spacing, default 5 / alert图文间距 默认5
    public var space : Float = 5
    
    /// Alert container color, default white / alert主体颜色 默认白色
    public var tintColor : UIColor = .whiteBGColor
    /// Alert background color, default black with 0.5 alpha / alert背景颜色 默认黑色半透明
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.5)
    /// Alert divider line color, default light gray / alert分割线颜色 默认浅灰色
    public var lineColor : UIColor = .lightGray
    /// Default mask type, color / 默认蒙版类型 颜色
    public var maskType : MaskType = .color
    /// Shadow color, default clear / 阴影颜色 默认clear
    public var shadowColor : CGColor = UIColor.clear.cgColor
    /// Shadow opacity, default 0.5 / 阴影Opacity 默认0.5
    public var shadowOpacity : Float = 0.5
    /// Shadow radius, default 5 / 阴影Radius 默认5
    public var shadowRadius : CGFloat = 5
    /// Alert title font, default system 21 / alert标题字体 默认系统21
    public var titleFont : UIFont = UIFont.systemFont(ofSize: 21)
    /// Alert title text color, default text color / alert标题字体颜色 默认文本颜色
    public var titleColor : UIColor = .textColor
    /// Alert message font, default system 14 / alert信息字体 默认系统14
    public var textFont : UIFont = UIFont.systemFont(ofSize: 14)
    /// Alert message text color, default text color / alert信息字体颜色 默认文本颜色
    public var textColor : UIColor = .textColor
    /// Alert button font, default system 15 / alert按钮字体 默认系统15
    public var buttonFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// Alert left button text color, default text color / alert左侧按钮字体颜色 默认文本颜色
    public var leftColor : UIColor = .textColor
    /// Alert right button text color, default text color / alert右侧按钮字体颜色 默认文本颜色
    public var rightColor : UIColor = .textColor

    /// Alert vertical padding, default 10 / alert背景与内容之间的上下边距 默认10
    public var verticalPadding : Float = 10
    /// Alert horizontal padding, default 10 / alert背景与内容之间的左右边距 默认10
    public var horizontalPadding : Float = 10
}

// MARK: - PopView Configuration / PopView配置
public class ShowPopViewConfig {
    /// Background blur effect / 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    /// Dismiss when tapping outside, default true / 点击其他地方是否消失 默认yes
    public var clickOutHidden = true
    /// Default mask type, color / 默认蒙版类型 颜色
    public var maskType : MaskType = .color
    /// Background color, default black with 0.3 alpha / 背景颜色 默认黑色半透明
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.3)
    /// Animation duration, default 0.3s / 执行动画时间 默认0.3
    public var animateDuration = 0.3
    /// Enable spring animation / 动画是否使用弹性
    public var animateDamping = true
    /// Enable animation / 是否使用动画
    public var isAnimate = true
    /// PopView show direction / 弹出视图样式位置
    public var showAnimateType : PopViewShowType? = .center
}

// MARK: - DropDown Configuration / DropDown配置
public class ShowDropDownConfig {
    /// Background blur effect / 背景蒙版 毛玻璃
    public var effectStyle = UIBlurEffect.Style.light
    /// Dismiss when tapping outside, default true / 点击其他地方是否消失 默认yes
    public var clickOutHidden = true
    /// Default mask type, color / 默认蒙版类型 颜色
    public var maskType : MaskType = .color
    /// Background color, default black with 0.3 alpha / 背景颜色 默认黑色半透明
    public var bgColor : UIColor = UIColor.black.withAlphaComponent(0.3)
    /// Animation duration, default 0.3s / 执行动画时间 默认0.3
    public var animateDuration = 0.3
    /// Enable spring animation / 动画是否使用弹性
    public var animateDamping = true
    /// Enable animation / 是否使用动画
    public var isAnimate = true
    /// DropDown starting Y position, default 88 / 弹出视图起始Y位置 默认88
    public var fromY : CGFloat = 88
}

// MARK: - UIColor extensions for dark mode support / UIColor扩展 支持深色模式
extension UIColor {
    
    /// Adaptive black color for dark mode / 深色模式自适应黑色
    @available(iOS 13.0, *)
    static let blackChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.110, green: 0.110, blue: 0.110, alpha: 1.0)
        } else {
            return UIColor.black
        }
    }

    /// Adaptive white color for dark mode / 深色模式自适应白色
    @available(iOS 13.0, *)
    static let whiteChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0.110, green: 0.110, blue: 0.110, alpha: 1.0)
        } else {
            return UIColor.white
        }
    }

    /// Adaptive text color for dark mode / 深色模式自适应文本色
    @available(iOS 13.0, *)
    static let textChangeColor = UIColor { (trainCollection) -> UIColor in
        if trainCollection.userInterfaceStyle == .dark {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
    /// Background black color with dark mode support / 支持深色模式的背景黑色
    static var blackBGColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.blackChangeColor
        }else{
            return UIColor.black
        }
    }
    
    /// Background white color with dark mode support / 支持深色模式的背景白色
    static var whiteBGColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.whiteChangeColor
        }else{
            return UIColor.white
        }
    }
    
    /// Text color with dark mode support / 支持深色模式的文本色
    static var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.textChangeColor
        }else{
            return UIColor.black
        }
    }
}
