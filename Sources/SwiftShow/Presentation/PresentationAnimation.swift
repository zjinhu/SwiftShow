//
//  PresentationAnimation.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit

/// Animation context / 动画上下文
public struct AnimationContext {
    
    /// Container view / 容器视图
    public let containerView: UIView
    
    /// Initial frame / 初始frame
    public let initialFrame: CGRect
    
    /// Final frame / 最终frame
    public let finalFrame: CGRect
    
    /// Whether this is a presenting animation / 是否为展示动画
    public let isPresenting: Bool
    
    /// Source view controller / 源视图控制器
    public let fromViewController: UIViewController?
    
    /// Destination view controller / 目标视图控制器
    public let toViewController: UIViewController?
    
    /// Source view / 源视图
    public let fromView: UIView?
    
    /// Destination view / 目标视图
    public let toView: UIView?
    
    /// Animating view controller / 动画中的视图控制器
    public let animatingViewController: UIViewController?
    
    /// Animating view / 动画中的视图
    public let animatingView: UIView?
    
}

/// Transition animation class, subclass to create custom animations / 转场动画类，可继承此类自定义转场动画
open class PresentationAnimation: NSObject {
    
    /// Animation options / 动画选项
    public var options: AnimationOptions
    
    /// Starting origin / 起始位置
    public var origin: PresentationOrigin?
    
    public init(options: AnimationOptions = .normal(duration: 0.3), origin: PresentationOrigin? = nil) {
        self.options = options
        self.origin = origin
    }
    
    /// Calculate initial frame for animated view / 计算动画view初始Frame
    ///
    /// - Parameters:
    ///   - containerFrame: Container view frame / 容器view的frame
    ///   - finalFrame: Final frame of the animated view / 动画view最终frame
    /// - Returns: Initial frame of the animated view / 动画view初始Frame
    open func transformInitialFrame(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        guard let origin = origin else { return finalFrame }
        var initialFrame = finalFrame
        switch origin {
        case .center:
            initialFrame.origin = CGPoint(x: (containerFrame.width - finalFrame.width) / 2, y: (containerFrame.height - finalFrame.height) / 2)
        case .bottomOutOfLine:
            initialFrame.origin = CGPoint(x: (containerFrame.width - finalFrame.width) / 2, y: containerFrame.height)
        case .leftOutOfLine:
            initialFrame.origin = CGPoint(x: -finalFrame.width, y: (containerFrame.height - finalFrame.height) / 2)
        case .rightOutOfLine:
            initialFrame.origin = CGPoint(x: containerFrame.width + finalFrame.width, y: (containerFrame.height - finalFrame.height) / 2)
        case .topOutOfLine:
            initialFrame.origin = CGPoint(x: (containerFrame.width - finalFrame.width) / 2, y: -finalFrame.height)
        case .custom(let center):
            initialFrame.origin = CGPoint(x: center.x - finalFrame.width / 2, y: center.y - finalFrame.height / 2)
        }
        return initialFrame
    }
    
    /// Before animation (prepare for animation, subclasses can override) / 动画开始前（做动画开始前的准备工作，子类可覆写）
    ///
    /// - Parameter animationContext: Animation context / 动画上下文
    open func beforeAnimation(animationContext: AnimationContext) {
        var initialFrame = animationContext.finalFrame
        if animationContext.isPresenting {
            initialFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: initialFrame)
        }
        animationContext.animatingView?.frame = initialFrame
    }
    
    /// Perform animation (execute the actual animation, subclasses can override) / 动画执行（做动画的具体执行动作，子类可覆写）
    ///
    /// - Parameter animationContext: Animation context / 动画上下文
    open func performAnimation(animationContext: AnimationContext) {
        var finalFrame = animationContext.finalFrame
        if !animationContext.isPresenting {
            finalFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: finalFrame)
        }
        animationContext.animatingView?.frame = finalFrame
    }
    
    /// After animation (cleanup after animation, subclasses can override) / 动画完成后（做动画完成的清理工作，子类可覆写）
    ///
    /// - Parameter animationContext: Animation context / 动画上下文
    open func afterAnimation(animationContext: AnimationContext) {
        
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension PresentationAnimation: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return options.duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let isPresenting = (toViewController?.presentingViewController == fromViewController)
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        
        let initialFrame = transitionContext.initialFrame(for: animatingVC!)
        let finalFrame = transitionContext.finalFrame(for: animatingVC!)
        
        let animationContext = AnimationContext(containerView: containerView,
                                                initialFrame: initialFrame,
                                                finalFrame: finalFrame,
                                                isPresenting: isPresenting,
                                                fromViewController: fromViewController,
                                                toViewController: toViewController,
                                                fromView: fromView,
                                                toView: toView,
                                                animatingViewController: animatingVC,
                                                animatingView: animatingView)
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        switch options {
        case let .normal(duration):
            normalAnimate(animationContext: animationContext,
                          transitionContext: transitionContext,
                          duration: duration)
        case let .spring(duration, delay, damping, velocity):
            springAnimate(animationContext: animationContext,
                          transitionContext: transitionContext,
                          duration: duration,
                          delay: delay,
                          damping: damping,
                          velocity: velocity)
        }
    }
    
    /// Normal animation / 普通动画
    private func normalAnimate(animationContext: AnimationContext,
                               transitionContext: UIViewControllerContextTransitioning,
                               duration: TimeInterval) {
        beforeAnimation(animationContext: animationContext)
        UIView.animate(withDuration: duration, animations: {
            self.performAnimation(animationContext: animationContext)
        }) { (completed) in
            self.afterAnimation(animationContext: animationContext)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    /// Spring animation / 弹簧动画
    private func springAnimate(animationContext: AnimationContext,
                               transitionContext: UIViewControllerContextTransitioning,
                               duration: TimeInterval,
                               delay: TimeInterval,
                               damping: CGFloat,
                               velocity: CGFloat) {
        beforeAnimation(animationContext: animationContext)
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: .curveEaseOut,
                       animations: {
            self.performAnimation(animationContext: animationContext)
        }) { (completed) in
            self.afterAnimation(animationContext: animationContext)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

/// Horizontal flip animation / 水平翻转动画
public class FlipHorizontalAnimation: PresentationAnimation {
    
    public override func performAnimation(animationContext: AnimationContext) {
        animationContext.toView?.layer.zPosition = 999
        animationContext.fromView?.layer.zPosition = 999
        
        var fromViewRotationPerspectiveTrans = CATransform3DIdentity
        fromViewRotationPerspectiveTrans.m34 = -0.003
        fromViewRotationPerspectiveTrans = CATransform3DRotate(fromViewRotationPerspectiveTrans, .pi / 2.0, 0.0, -1.0, 0.0)
        
        var toViewRotationPerspectiveTrans = CATransform3DIdentity
        toViewRotationPerspectiveTrans.m34 = -0.003
        toViewRotationPerspectiveTrans = CATransform3DRotate(toViewRotationPerspectiveTrans, .pi / 2.0, 0.0, 1.0, 0.0)
        
        animationContext.toView?.layer.transform = toViewRotationPerspectiveTrans
        
        UIView.animate(withDuration: options.duration, delay: 0, options: .curveLinear, animations: {
            animationContext.fromView?.layer.transform = fromViewRotationPerspectiveTrans
        }) { (_) in
            UIView.animate(withDuration: self.options.duration, delay: 0, options: .curveLinear, animations: {
                animationContext.toView?.layer.transform = CATransform3DMakeRotation(.pi / 2.0, 0.0, 0.0, 0.0)
            }, completion: nil)
        }
        
    }
}

/// Cross zoom animation / 交叉缩放动画
public class CrossZoomAnimation: PresentationAnimation {
    
    private var scale: CGFloat
    
    public init(scale: CGFloat, options: AnimationOptions = .normal(duration: 0.3), origin: PresentationOrigin? = nil) {
        self.scale = scale
        super.init(options: options, origin: origin)
    }
    
    public override func beforeAnimation(animationContext: AnimationContext) {
        animationContext.animatingView?.frame = animationContext.finalFrame
        let translate = calculateTranslate(animationContext: animationContext)
        animationContext.animatingView?.transform = animationContext.isPresenting ? CGAffineTransform(translationX: translate.x, y: translate.y).scaledBy(x: scale, y: scale) : .identity
    }
    
    public override func performAnimation(animationContext: AnimationContext) {
        let translate = calculateTranslate(animationContext: animationContext)
        animationContext.animatingView?.transform = animationContext.isPresenting ? .identity : CGAffineTransform(translationX: translate.x, y: translate.y).scaledBy(x: scale, y: scale)
    }
    
    /// Calculate translation offset / 计算平移偏移量
    private func calculateTranslate(animationContext: AnimationContext) -> CGPoint {
        let finalFrame = animationContext.finalFrame
        let initialFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: finalFrame)
        let translate = CGPoint(x: initialFrame.minX - finalFrame.minX , y: initialFrame.minY - finalFrame.minY)
        return translate
    }
    
}

/// Cross dissolve (fade) animation / 交叉溶解（淡入淡出）动画
public class CrossDissolveAnimation: PresentationAnimation {
    
    public override func beforeAnimation(animationContext: AnimationContext) {
        super.beforeAnimation(animationContext: animationContext)
        animationContext.animatingView?.alpha = animationContext.isPresenting ? 0.0 : 1.0
    }
    
    public override func performAnimation(animationContext: AnimationContext) {
        super.performAnimation(animationContext: animationContext)
        animationContext.animatingView?.alpha = animationContext.isPresenting ? 1.0 : 0.0
    }
    
    public override func afterAnimation(animationContext: AnimationContext) {
        super.afterAnimation(animationContext: animationContext)
        animationContext.animatingView?.alpha = 1.0
    }
    
}
