//
//  ToastView.swift
//  SwiftShow
//
//  Created by iOS on 2020/1/16.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
import SnapKit

/// Toast notification view / Toast通知视图
class ToastView: UIView {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initialize toast view / 初始化Toast视图
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subTitle: Subtitle text / 副标题文本
    ///   - image: Image (optional) / 图片（可选）
    ///   - config: Toast configuration / Toast配置
    init(title: String,
         subTitle: String? = nil,
         image: UIImage? = nil,
         config : ShowToastConfig) {

        super.init(frame: CGRect.zero)
        
        // Container view for toast content / Toast内容容器
        let containerView = UIView()
        addSubview(containerView)
        containerView.backgroundColor = config.bgColor
        containerView.layer.cornerRadius = config.cornerRadius
        if config.shadowColor != UIColor.clear.cgColor {
            containerView.layer.shadowColor = config.shadowColor
            containerView.layer.shadowOpacity = config.shadowOpacity
            containerView.layer.shadowRadius = config.shadowRadius
            containerView.layer.shadowOffset = CGSize.zero
        }
        containerView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        // Common view with title/subtitle/image / 通用图文视图
        let view = CommonView(title: title,
                              subtitle: subTitle,
                              image: image,
                              imageType: config.imageType,
                              spaceImage: config.spaceImage,
                              spaceText: config.spaceText)
        
        view.titleLabel.textColor = config.titleColor
        view.titleLabel.font = config.titleFont
        
        view.subtitleLabel.textColor = config.subTitleColor
        view.subtitleLabel.font = config.subTitleFont
        
        containerView.addSubview(view)

        view.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(config.padding)
            make.bottom.right.equalToSuperview().offset(-config.padding)
            make.width.lessThanOrEqualTo(config.maxWidth)
            make.height.lessThanOrEqualTo(config.maxHeight)
        }
    }

}
