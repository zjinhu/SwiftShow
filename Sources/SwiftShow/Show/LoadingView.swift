//
//  LoadingView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

/// Loading HUD view / 加载指示器视图
class LoadingView: UIView {
 
    /// Initialize loading view / 初始化加载视图
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - config: Loading configuration / 加载配置
    init(title: String? = nil,
         subTitle: String? = nil, 
         config : ShowLoadingConfig) {
 
        super.init(frame: CGRect.zero)
        
        // Blur effect background view / 毛玻璃效果背景视图
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: config.effectStyle))
        addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Apply mask type / 应用遮罩类型
        switch config.maskType {
        case .effect:
            effectView.isHidden = false
            backgroundColor = .clear
        default:
            effectView.isHidden = true
            backgroundColor = config.bgColor
        }
        
        // Container view for loading content / 加载内容容器视图
        let containerView = UIView.init()
        addSubview(containerView)
        
        containerView.backgroundColor = config.tintColor
        containerView.layer.cornerRadius = config.cornerRadius
        if config.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = config.shadowColor
            containerView.layer.shadowOpacity = config.shadowOpacity
            containerView.layer.shadowRadius = config.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        // Common view with title/subtitle/image / 通用图文视图
        let loadingView = CommonView(title: title,
                              subtitle: subTitle,
                              image: UIImage(),
                              imageType: config.imageType,
                              spaceImage: config.spaceImage,
                              spaceText: config.spaceText)
        
        loadingView.titleLabel.textColor = config.titleColor
        loadingView.titleLabel.font = config.titleFont
        
        loadingView.subtitleLabel.textColor = config.subTitleColor
        loadingView.subtitleLabel.font = config.subTitleFont
        
        containerView.addSubview(loadingView)

        loadingView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(config.verticalPadding)
            make.bottom.equalToSuperview().offset(-config.verticalPadding)
            make.left.equalToSuperview().offset(config.horizontalPadding)
            make.right.equalToSuperview().offset(-config.horizontalPadding)
            make.width.lessThanOrEqualTo(config.maxWidth)
        }
        
        // Image animation or activity indicator / 图片动画或菊花指示器
        if let array = config.imagesArray{
            guard let image = array.first else {
                return
            }
            loadingView.imageView.image = image
            loadingView.imageView.animationImages = config.imagesArray
            loadingView.imageView.animationDuration = config.animationTime
            loadingView.imageView.animationRepeatCount = 0
            loadingView.imageView.startAnimating()
        }else{
            // Default activity indicator (spinner) / 默认菊花指示器
            let activityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
            activityIndicatorView.color = config.activityColor
            let transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            activityIndicatorView.transform = transform
            activityIndicatorView.startAnimating()
            loadingView.imageView.addSubview(activityIndicatorView)
            activityIndicatorView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
