//
//  SettingButton.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 2/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public final class SettingButton: UIButton {
    
    private let iconName: String
    private let title: String
    private let rightTitle: String?
    private let isHiddenArrowRight: Bool

    private lazy var leftIconLabel: UIImageView = {
        let title = iconName
        let view = UIImageView(image: UIImage(systemName: title))
        view.tintColor = DesignSystemAsset.routeTimeColor.color
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabels: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 15)
        label.textColor = DesignSystemAsset.settingColor.color
        label.text = title
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font
        = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 13)
        label.textColor = DesignSystemAsset.settingColor.color
        label.text = rightTitle
        return label
    }()

    private let arrowRightLabel: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "chevron.right"))
        view.tintColor = DesignSystemAsset.routeTimeColor.color
        return view
    }()

    public init(
        iconName: String,
        title: String,
        rightTitle: String?,
        isHiddenArrowRight: Bool
    ) {
        self.iconName = iconName
        self.title = title
        self.rightTitle = rightTitle
        self.isHiddenArrowRight = isHiddenArrowRight
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [titleLabels, rightLabel, arrowRightLabel, leftIconLabel]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        [leftIconLabel, titleLabels]
            .forEach { addSubview($0) }
        
        if isHiddenArrowRight {
            addSubview(rightLabel)
            rightLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 2
            ).isActive = true
            rightLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ).isActive = true
            
        } else {
            addSubview(arrowRightLabel)
            arrowRightLabel.topAnchor.constraint(
                equalTo: topAnchor
            ).isActive = true
            arrowRightLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ).isActive = true
        }
        
        NSLayoutConstraint.activate([
            leftIconLabel.topAnchor.constraint(
                equalTo: topAnchor
            ),
            leftIconLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            leftIconLabel.widthAnchor.constraint(equalToConstant: 20),
            leftIconLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabels.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 2
            ),
            titleLabels.leadingAnchor.constraint(
                equalTo: leftIconLabel.trailingAnchor,
                constant: 15
            ),
        ])
    }
}
