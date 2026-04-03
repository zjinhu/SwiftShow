//
//  PresentedViewType.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

/// Configuration for presented view / presentedView的设置
public struct PresentedViewComponent {
    
    /// Size of the presented view / presentedView的size
    public var contentSize: CGSize
    
    /// Final destination of the presented view / presentedView最终展示位置
    public var destination: PresentationDestination = .bottomBaseline
    
    /// Present transition animation, nil uses destination-based default / present转场动画，为nil则基于destination使用
    public var presentTransitionType: TransitionType?
    
    /// Dismiss transition animation, nil uses destination-based default / dismiss转场动画，为nil则基于destination使用
    public var dismissTransitionType: TransitionType?
    
    /// Enable tap background to dismiss / 是否开启点击背景dismiss
    public var canTapBGDismiss: Bool = true
    
    /// Enable pan gesture to dismiss / 是否开启pan手势dismiss
    public var canPanDismiss: Bool = true
    
    /// Pan gesture direction, nil uses destination-based default / pan手势方向，为nil则基于destination使用
    public var panDismissDirection: PanDismissDirection?
    
    /// Keyboard translation type, default is close to PresentedView / 键盘出现的平移方式，默认贴近PresentedView
    public var keyboardTranslationType: KeyboardTranslationType = .unabgeschirmt(compress: true)

    /// Keyboard padding, default 20 / 键盘间隔，默认20
    public var keyboardPadding: CGFloat = 20
    
    /// Initializer / 初始化方法
    ///
    /// - Parameters:
    ///   - contentSize: Size of the presented view / presentedView的size
    ///   - destination: Final destination of the presented view / presentedView最终展示位置
    ///   - presentTransitionType: Present transition animation / present转场动画
    ///   - dismissTransitionType: Dismiss transition animation / dismiss转场动画
    ///   - canTapBGDismiss: Enable tap background to dismiss / 是否开启点击背景dismiss
    ///   - canPanDismiss: Enable pan gesture to dismiss / 是否开启pan手势dismiss
    ///   - panDismissDirection: Pan gesture direction / pan手势方向
    ///   - keyboardTranslationType: Keyboard translation type, default close to PresentedView / 键盘出现的平移方式，默认贴近PresentedView
    ///   - keyboardPadding: Keyboard padding, default 20 / 键盘间隔，默认20
    public init(contentSize: CGSize,
                destination: PresentationDestination = .bottomBaseline,
                presentTransitionType: TransitionType? = nil,
                dismissTransitionType: TransitionType? = nil,
                canTapBGDismiss: Bool = true,
                canPanDismiss: Bool = true,
                panDismissDirection: PanDismissDirection? = nil,
                keyboardTranslationType: KeyboardTranslationType = .unabgeschirmt(compress: true),
                keyboardPadding: CGFloat = 20) {
        self.contentSize = contentSize
        self.destination = destination
        self.presentTransitionType = presentTransitionType
        self.dismissTransitionType = dismissTransitionType
        self.canTapBGDismiss = canTapBGDismiss
        self.canPanDismiss = canPanDismiss
        self.panDismissDirection = panDismissDirection
        self.keyboardTranslationType = keyboardTranslationType
        self.keyboardPadding = keyboardPadding
    }
    
}

/// Protocol that presented view must conform to / presentedView必须遵守此协议
public protocol PresentedViewType {
    
    /// Configuration for presented view / presentedView的设置
    var presentedViewComponent: PresentedViewComponent? { get set }
    
}

extension PresentedViewType {
    
    var presentTransitionType: TransitionType {
        return presentedViewComponent?.presentTransitionType ?? .translation(origin: .center)
    }
    
    var dismissTransitionType: TransitionType {
        return presentedViewComponent?.dismissTransitionType ?? presentTransitionType
    }
    
}
