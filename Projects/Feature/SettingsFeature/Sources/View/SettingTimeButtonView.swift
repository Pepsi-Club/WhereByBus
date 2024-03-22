//
//  SettingTimeButtonView.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 3/10/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

public final class SettingTimeButtonView: UIView {
    
    private let width: CGFloat = 111
    private let height: CGFloat = 40
    
    public let firstBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DesignSystemAsset.gray3.color
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        config.background.cornerRadius = 20
        config.title = "1분 전"
        let button = UIButton(configuration: config)
        return button
    }()
    
    public let secondBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DesignSystemAsset.gray3.color
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        config.background.cornerRadius = 20
        config.title = "3분 전"
        let button = UIButton(configuration: config)
        return button
    }()
    public let thirdBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DesignSystemAsset.gray3.color
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        config.background.cornerRadius = 20
        config.title = "5분 전"
        let button = UIButton(configuration: config)
        return button
    }()
    public let fourthBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = DesignSystemAsset.gray3.color
        config.baseForegroundColor = DesignSystemAsset.gray5.color
        config.background.cornerRadius = 20
        config.title = "10분 전"
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 23
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [stackView, firstBtn, secondBtn, thirdBtn, fourthBtn]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [firstBtn, secondBtn, thirdBtn, fourthBtn]
            .forEach {
                stackView.addArrangedSubview($0)
                
                $0.widthAnchor.constraint(
                    equalToConstant: width
                ).isActive = true
                $0.heightAnchor.constraint(
                    equalToConstant: height
                ).isActive = true
            }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
}
