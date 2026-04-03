//
//  PresentationEnums.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

/// Pan gesture swipe direction / pan手势滑动方向
///
/// - down: Downward / 向下
/// - up: Upward / 向上
/// - left: Leftward / 向左
/// - right: Rightward / 向右
public enum PanDismissDirection {
    
    case down
    case up
    case left
    case right
}

/// Starting position for present animation / present的起始位置
///
/// - center: Screen center / 屏幕中心
/// - bottomOutOfLine: Below screen bottom / 屏幕底部以下
/// - leftOutOfLine: Beyond screen left edge / 屏幕左边以外
/// - rightOutOfLine: Beyond screen right edge / 屏幕右边以外
/// - topOutOfLine: Above screen top / 屏幕上部以上
/// - custom: Custom center point / 自定义中心点
public enum PresentationOrigin: Equatable {
    
    case center
    case bottomOutOfLine
    case leftOutOfLine
    case rightOutOfLine
    case topOutOfLine
    case custom(center: CGPoint)
    
    // MARK: - Equatable
    public static func == (lhs: PresentationOrigin, rhs: PresentationOrigin) -> Bool {
        switch (lhs, rhs) {
        case (.center, .center):
            return true
        case (.bottomOutOfLine, .bottomOutOfLine):
            return true
        case (.leftOutOfLine, .leftOutOfLine):
            return true
        case (.rightOutOfLine, .rightOutOfLine):
            return true
        case (.topOutOfLine, .topOutOfLine):
            return true
        case (.custom(let lhsCenter), .custom(let rhsCenter)):
            return lhsCenter == rhsCenter
        default:
            return false
        }
    }
}

/// Final destination for present animation / present的最终位置
///
/// - center: Screen center / 屏幕中心
/// - bottomBaseline: Based on screen bottom / 基于屏幕底部
/// - leftBaseline: Based on screen left edge / 基于屏幕左边
/// - rightBaseline: Based on screen right edge / 基于屏幕右边
/// - topBaseline: Based on screen top / 基于屏幕上部
/// - custom: Custom center point / 自定义中心点
public enum PresentationDestination: Equatable {
    
    case center
    case bottomBaseline
    case leftBaseline
    case rightBaseline
    case topBaseline
    case custom(center: CGPoint)
    
    /// Pan gesture direction / pan手势方向
    var panDirection: PanDismissDirection {
        switch self {
        case .center, .bottomBaseline, .custom:
            return .down
        case .leftBaseline:
            return .left
        case .rightBaseline:
            return .right
        case .topBaseline:
            return .up
        }
    }
    
    /// Default starting position / 默认的起始位置
    var defaultOrigin: PresentationOrigin {
        switch self {
        case .center:
            return .center
        case .leftBaseline:
            return .leftOutOfLine
        case .rightBaseline:
            return .rightOutOfLine
        case .topBaseline:
            return .topOutOfLine
        default:
            return .bottomOutOfLine
        }
    }
    
    // MARK: - Equatable
    public static func == (lhs: PresentationDestination, rhs: PresentationDestination) -> Bool {
        switch (lhs, rhs) {
        case (.center, .center):
            return true
        case (.bottomBaseline, .bottomBaseline):
            return true
        case (.leftBaseline, .leftBaseline):
            return true
        case (.rightBaseline, .rightBaseline):
            return true
        case (.topBaseline, .topBaseline):
            return true
        case (.custom(let lhsCenter), .custom(let rhsCenter)):
            return lhsCenter == rhsCenter
        default:
            return false
        }
    }
}

/// Transition animation type / 转场动画类型
///
/// - translation: Translation / 平移
/// - crossDissolve: Fade in/out / 淡入淡出
/// - crossZoom: Zoom / 缩放
/// - flipHorizontal: Horizontal flip / 水平翻转
/// - custom: Custom animation / 自定义动画
public enum TransitionType: Equatable {
    
    case translation(origin: PresentationOrigin)
    case crossDissolve
    case crossZoom
    case flipHorizontal
    case custom(animation: PresentationAnimation)
    
    var animation: PresentationAnimation {
        switch self {
        case .translation(let origin):
            return PresentationAnimation(origin: origin)
        case .crossDissolve:
            return CrossDissolveAnimation()
        case .crossZoom:
            return CrossZoomAnimation(scale: 0.1)
        case .flipHorizontal:
            return FlipHorizontalAnimation()
        case .custom(let animation):
            return animation
        }
    }
    
    // MARK: - Equatable
    public static func == (lhs: TransitionType, rhs: TransitionType) -> Bool {
        switch (lhs, rhs) {
        case (.translation(let lhsOrigin), .translation(let rhsOrigin)):
            return lhsOrigin == rhsOrigin
        case (.crossDissolve, .crossDissolve):
            return true
        case (.flipHorizontal, .flipHorizontal):
            return true
        case (.crossZoom, .crossZoom):
            return true
        case (.custom(let lhsAnimation), .custom(let rhsAnimation)):
            return lhsAnimation == rhsAnimation
        default:
            return false
        }
    }
}

/// Animation options / 动画选项设置
///
/// - normal: Normal animation / 正常动画
/// - spring: Spring animation / 弹簧动画
public enum AnimationOptions {
    
    case normal(duration: TimeInterval)
    case spring(duration: TimeInterval, delay: TimeInterval, damping: CGFloat, velocity: CGFloat)
    
    var duration: TimeInterval {
        switch self {
        case .normal(let duration):
            return duration
        case .spring(let duration, _, _, _):
            return duration
        }
    }
}

/// Keyboard appearance translation type / 键盘出现的平移方式
///
/// - unabgeschirmt: Do not block presentedView, compress: whether to keep PresentedView close to the keyboard / 不遮挡PresentedView，compress: 键盘是否贴近PresentedView
/// - compressInputView: Close to the input view / 贴近输入框
public enum KeyboardTranslationType {
    
    case unabgeschirmt(compress: Bool)
    case compressInputView
}
