//
//  SearchBusStopBtn.swift
//  DesignSystem
//
//  Created by gnksbm on 1/23/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class SearchBusStopBtn: UIButton {
    private let font: UIFont
    
    public init(
        title: String? = nil,
        image: UIImage? = nil,
        font: UIFont = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 14
        ),
        color: UIColor = DesignSystemAsset.mainColor.color
    ) {
        self.font = font
        super.init(frame: .zero)
        let attributedTitle = makeAttributedTitle(
            title: title
        )
        let config = makeConfiguration(
            attributedTitle: attributedTitle,
            image: image,
            color: color
        )
        configuration = config
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel,
              let imageView = imageView
        else { return }
        
        let space: CGFloat = 10
        titleLabel.frame.origin.x = layoutMargins.left + space
        
        let imageViewX 
        = bounds.width - imageView.bounds.width - layoutMargins.right - space
        imageView.frame.origin.x = imageViewX
        
        titleLabel.center.y = bounds.midY
        imageView.center.y = bounds.midY
    }
    
    private func makeConfiguration(
        attributedTitle: AttributedString?,
        image: UIImage?,
        color: UIColor
    ) -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = DesignSystemAsset.gray3.color
        config.baseForegroundColor = color
        config.cornerStyle = .large
        config.contentInsets = .init(
            top: 12,
            leading: 0,
            bottom: 12,
            trailing: 0
        )
        // MARK: Title
        config.attributedTitle = attributedTitle
        // MARK: Imgae
        config.image = image
        config.imagePadding = 5
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = makeImgConfig()
        return config
    }
    
    public func updateTitle(title: String) {
        configuration?.attributedTitle = makeAttributedTitle(
            title: title
        )
    }
    
    private func makeAttributedTitle(
        title: String?
    ) -> AttributedString? {
        var attributedString: AttributedString?
        var titleContainer = AttributeContainer()
        titleContainer.font = font
        attributedString = AttributedString(
            title ?? "a",
            attributes: titleContainer
        )
        return attributedString
    }
    
    private func makeImgConfig() -> UIImage.SymbolConfiguration {
        UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 14)
        )
    }
}
