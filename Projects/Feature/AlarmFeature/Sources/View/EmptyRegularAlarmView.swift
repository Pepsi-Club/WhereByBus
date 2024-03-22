//
//  EmptyRegularAlarmView.swift
//  AlarmFeatureDemo
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class EmptyRegularAlarmView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.bus.image
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 15
        )
        label.textColor = DesignSystemAsset.gray6.color
        label.textAlignment = .center
        label.numberOfLines = 2
        let message1 = NSAttributedString(
            string: "특정 시간대에 자주 타는 버스가 있다면?\n",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
                    size: 15
                )
            ]
        )
        let message2 = NSAttributedString(
            string: "정기 알람 등록하러 가기",
            attributes: [
                .font: DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
                    size: 20
                ),
                .foregroundColor: DesignSystemAsset.bottonBtnColor.color
            ]
        )
        let attributedString = NSMutableAttributedString()
        attributedString.append(message1)
        attributedString.append(message2)
        label.attributedText = attributedString
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        
        [imageView, messageLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -50
            ),
            
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
        ])
    }
}
