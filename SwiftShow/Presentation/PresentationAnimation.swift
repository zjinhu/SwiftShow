//
//  PresentationAnimation.swift
//  SwiftDialog
//
//  Created by iOS on 2020/2/5.
//  Copyright © 2020 iOS. All rights reserved.
//


import Foundation
import UIKit
/// 动画上下文
public struct AnimationContext {
    
    public let containerView: UIView
    
    public let initialFrame: CGRect
    
    public let finalFrame: CGRect
    
    public let isPresenting: Bool
    
    public let fromViewController: UIViewController?
    
    public let toViewController: UIViewController?
    
    public let fromView: UIView?
    
    public let toView: UIView?
    
    public let animatingViewController: UIViewController?
    
    public let animatingView: UIView?
    
}

/// 转场动画类，可继承此类自定转场动画
open class PresentationAnimation: NSObject {
    
    public var options: AnimationOptions
    public var origin: PresentationOrigin?
    
    public init(options: AnimationOptions = .normal(duration: 0.3), origin: PresentationOrigin? = nil) {
        self.options = options
        self.origin = origin
    }
    
    /// 计算动画view初始Frame
    ///
    /// - Parameters:
    ///   - containerFrame: 容器view的frame
    ///   - finalFrame: 动画view最终frame
    /// - Returns: 动画view初始Frame
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
    
    /// 动画开始前（做动画开始前的准备工作，子类可覆写）
    ///
    /// - Parameter animationContext: 动画上下文
    open func beforeAnimation(animationContext: AnimationContext) {
        var initialFrame = animationContext.finalFrame
        if animationContext.isPresenting {
            initialFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: initialFrame)
        }
        animationContext.animatingView?.frame = initialFrame
    }
    
    /// 动画执行（做动画的具体执行动作，子类可覆写）
    ///
    /// - Parameter animationContext:  动画上下文
    open func performAnimation(animationContext: AnimationContext) {
        var finalFrame = animationContext.finalFrame
        if !animationContext.isPresenting {
            finalFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: finalFrame)
        }
        animationContext.animatingView?.frame = finalFrame
    }
    
    /// 动画完成后（做动画完成的清理工作，子类可覆写）
    ///
    /// - Parameter animationContext: 动画上下文
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
    
    private func calculateTranslate(animationContext: AnimationContext) -> CGPoint {
        let finalFrame = animationContext.finalFrame
        let initialFrame = transformInitialFrame(containerFrame: animationContext.containerView.frame, finalFrame: finalFrame)
        let translate = CGPoint(x: initialFrame.minX - finalFrame.minX , y: initialFrame.minY - finalFrame.minY)
        return translate
    }
    
}

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
