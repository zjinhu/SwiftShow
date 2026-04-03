//
//  UIViewController+Presentation.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

/// UIViewController conforming to PresentedViewType protocol / 遵守PresentedViewType协议的UIViewController
public typealias PresentationViewController = UIViewController & PresentedViewType

extension UIViewController {
    
    /// Custom present method / 自定义present方法
    /// - Parameters:
    ///   - viewController: View controller to present / 要展示的视图控制器
    ///   - animated: Whether to animate the presentation / 是否使用动画
    public func presentViewController(_ viewController: PresentationViewController, animated: Bool = true) {
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        present(viewController, animated: animated, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension UIViewController: @retroactive UIViewControllerTransitioningDelegate {
    
    /// Returns the presentation controller for custom presentations / 返回自定义展示的控制器
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    /// Returns the animation controller for presenting / 返回展示时的动画控制器
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let presentedVC = presented as? PresentedViewType else { return nil }
        return presentedVC.presentTransitionType.animation
    }
    
    /// Returns the animation controller for dismissing / 返回消失时的动画控制器
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let dismissedVC = dismissed as? PresentedViewType else { return nil }
        return dismissedVC.dismissTransitionType.animation
    }
    
}
