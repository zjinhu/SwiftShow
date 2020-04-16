//
//  Config.swift
//  SwiftShow
//
//  Created by iOS on 2020/4/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit
import JHButton_Swift

public enum MaskType {
    case color
    case effect
}

public enum ToastOffset {
    case top
    case center
    case bottom
}

public enum PopViewShowType {
    case top
    case left
    case bottom
    case right
    case center
}
//MARK: -- Toast
public class ShowToastConfig : NSObject{
    ///执行动画时间 默认0.5
    var animateDuration = 0.5
    ///Toast最大宽度  默认200
    var maxWidth : Float = 200
    ///Toast最大高度 默认500
    var maxHeight : Float = 500
    ///Toast默认停留时间 默认2秒
    var showTime : Double = 2.0
    ///Toast圆角 默认5
    var cornerRadius : CGFloat = 5
    ///Toast图文间距  默认0
    var space : Float = 0
    ///Toast字体  默认15
    var textFont : UIFont = UIFont.systemFont(ofSize: 15)
    ///Toast背景颜色 默认黑色
    var bgColor : UIColor = .black
    ///阴影颜色 默认clearcolor
    var shadowColor : CGColor = UIColor.clear.cgColor
    ///阴影Opacity 默认0.5
    var shadowOpacity : Float = 0.5
    ///阴影Radius 默认5
    var shadowRadius : CGFloat = 5
    /// Toast文字字体颜色 默认白色
    var textColor : UIColor = .white
    ///Toast图文混排样式 默认图片在左
    var imageType : JHImageButtonType = .imageButtonTypeLeft
    ///Toast背景与内容之间的内边距 默认10
    var padding : Float = 10
    ///Toast 在屏幕的位置（左右居中调节上下）默认100
    var offSet : Float = 100
    ///Toast 在屏幕的位置 默认中间
    var offSetType : ToastOffset = .center
}

//MARK: --Loading
public class ShowLoadingConfig : NSObject{
    /// 是否背景透传点击 默认false
    var enableEvent: Bool = false
    ///背景蒙版 毛玻璃
    var effectStyle = UIBlurEffect.Style.light
    ///loading最大宽度 默认130
    var maxWidth : Float = 130
    ///loading最大高度 默认130
    var maxHeight : Float = 130
    ///圆角大小 默认5
    var cornerRadius : CGFloat = 5
    ///加载框主体颜色 默认黑色
    var tintColor : UIColor = .black
    ///文字字体大小 默认系统字体15
    var textFont : UIFont = UIFont.systemFont(ofSize: 15)
    ///文字字体颜色 默认白色
    var textColor : UIColor = .white
    ///背景颜色 默认clear
    var bgColor : UIColor = .clear
    ///默认蒙版类型 背景色
    var maskType : MaskType = .color
    ///阴影颜色 默认clearcolor
    var shadowColor : CGColor = UIColor.clear.cgColor
    ///阴影Opacity 默认0.5
    var shadowOpacity : Float = 0.5
    ///阴影Radius 默认5
    var shadowRadius : CGFloat = 5
    ///图片动画类型 所需要的图片数组
    var imagesArray : [UIImage]?
    ///菊花颜色 不传递图片数组的时候默认使用菊花
    var activityColor : UIColor = .white
    ///图片动画时间 默认1.0
    var animationTime : Double = 1.0
    ///loading图文混排样式  默认图片在上
    var imageType : JHImageButtonType = .imageButtonTypeTop
    ///loading背景与内容之间的上下边距 默认20
    var verticalPadding : Float = 20
    ///loading背景与内容之间的左右边距 默认20
    var horizontalPadding : Float = 20
    ///loading文字与图片之间的距 默认0
    var space : Float = 0
}
    
//MARK: --Alert
public class ShowAlertConfig : NSObject{
    ///背景蒙版 毛玻璃
    var effectStyle = UIBlurEffect.Style.light
    ///执行动画时间
    var animateDuration = 0.5
    ///alert宽度
    var width : Float = 280
    ///alert最大高度
    var maxHeight : Float = 500
    ///alert按钮高度
    var buttonHeight : Float = 50
    ///alert圆角
    var cornerRadius : CGFloat = 5
    ///alert图文混排样式
    var imageType : JHImageButtonType = .imageButtonTypeTop
    ///alert图文间距
    var space : Float = 0
    ///alert标题字体
    var titleFont : UIFont = UIFont.systemFont(ofSize: 18)
    /// alert标题字体颜色
    var titleColor : UIColor = .black
    ///alert信息字体
    var textFont : UIFont = UIFont.systemFont(ofSize: 14)
    /// alert信息字体颜色
    var textColor : UIColor = .black
    ///alert按钮字体
    var buttonFont : UIFont = UIFont.systemFont(ofSize: 15)
    /// alert按钮字体颜色
    var leftColor : UIColor = .black
    var rightColor : UIColor = .black
    ///alert主体颜色 默认
    var tintColor : UIColor = .white
    ///alert背景颜色
    var bgColor : UIColor = UIColor.black.withAlphaComponent(0.5)
    ///alert分割线颜色
    var lineColor : UIColor = .lightGray
    ///默认蒙版类型
    var maskType : MaskType = .color
    ///阴影
    var shadowColor : CGColor = UIColor.clear.cgColor
    var shadowOpacity : Float = 0.5
    var shadowRadius : CGFloat = 5
}

//MARK: --pop
public class ShowPopViewConfig : NSObject{
    ///背景蒙版 毛玻璃
    var effectStyle = UIBlurEffect.Style.light
    ///点击其他地方是否消失 默认yes
    var clickOutHidden = true
    ///默认蒙版类型
    var maskType : MaskType = .color
    ///背景颜色 默认蒙版
    var bgColor : UIColor = UIColor.black.withAlphaComponent(0.3)
    ///执行动画时间
    var animateDuration = 0.3
    ///动画是否弹性
    var animateDamping = true
    ///动画是否弹性
    var isAnimate = true
    /// 弹出视图样式位置
    var showAnimateType : PopViewShowType? = .center
}
