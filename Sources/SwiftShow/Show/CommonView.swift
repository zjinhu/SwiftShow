//
//  CommonView.swift
//  SwiftShow
//
//  Created by 狄烨 on 2022/6/6.
//  Copyright © 2022 iOS. All rights reserved.
//

import Foundation
import UIKit

/// Common reusable view with image and text labels / 通用可复用图文视图
public class CommonView : UIStackView {
    
    /// Image view / 图片视图
    lazy var imageView: UIImageView = {
        let vi = UIImageView()
        vi.contentMode = .scaleAspectFit
        return vi
    }()
    
    /// Title label / 标题标签
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14, weight: .bold)
        lab.numberOfLines = 2
        return lab
    }()
    
    /// Subtitle label / 副标题标签
    lazy var subtitleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12, weight: .bold)
        lab.numberOfLines = 0
        lab.textColor = .systemGray
        return lab
    }()
    
    /// Initialize common view / 初始化通用视图
    /// - Parameters:
    ///   - title: Title text / 标题文本
    ///   - subtitle: Subtitle text / 副标题文本
    ///   - image: Image / 图片
    ///   - imageType: Image layout type (horizontal or vertical) / 图片布局类型（水平或垂直）
    ///   - spaceImage: Spacing between image and title / 图片与标题之间的间距
    ///   - spaceText: Spacing between title and subtitle / 标题与副标题之间的间距
    public init(title: String? = nil,
                subtitle: String? = nil,
                image: UIImage? = nil,
                imageType : ImageLayoutType = .top,
                spaceImage: CGFloat = 5,
                spaceText: CGFloat = 5) {
        
        super.init(frame: CGRect.zero)
        
        // Set axis based on image type / 根据图片类型设置轴向
        axis = imageType == .left ? .horizontal : .vertical
        spacing = image != nil && title != nil ? spaceImage : 0
        alignment = .center
        distribution = .fill
        
        // Add image if provided / 如果提供了图片则添加
        if let image = image{
            imageView.image = image
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
                imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
            ])
            addArrangedSubview(imageView)
        }
        
        // Add title and optional subtitle / 添加标题和可选的副标题
        if let title = title {
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.spacing = subtitle?.count == 0 ? 0 : spaceText
            vStack.alignment = .center
            
            titleLabel.text = title
            vStack.addArrangedSubview(titleLabel)
            
            if let subtitle = subtitle {
                subtitleLabel.text = subtitle
                vStack.addArrangedSubview(subtitleLabel)
            }

            addArrangedSubview(vStack)
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
