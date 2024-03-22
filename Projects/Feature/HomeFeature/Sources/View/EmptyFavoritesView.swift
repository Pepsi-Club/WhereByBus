//
//  EmptyFavoritesView.swift
//  HomeFeature
//
//  Created by gnksbm on 2/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class EmptyFavoritesView: UIView {
    private let starImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = DesignSystemAsset.emptyFavoritesStars.image
        return imgView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 16,
            weight: .thin
        )
        label.text = "다음 버스 도착 시간까지 알고 싶다면\n즐겨찾기를 추가해보세요."
        label.numberOfLines = 2
        label.textColor = DesignSystemAsset.bottonBtnColor.color
        label.textAlignment = .center
        return label
    }()
    
    private let exampleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20,
            weight: .light
        )
        label.text = "ex"
        label.textColor = DesignSystemAsset.blueGray.color
        label.transform = CGAffineTransform(rotationAngle: -0.3)
        return label
    }()
    
    private let exampleRouteNumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "777"
        label.textColor = DesignSystemAsset.gray4.color
        return label
    }()
    
    private let exampleArrivalInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        let remainingString = NSAttributedString(
            string: "곧 도착",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20),
                .foregroundColor: DesignSystemAsset.lightRed.color
            ]
        )
        let timeString = NSAttributedString(
            string: "\n10분",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18),
                .foregroundColor: DesignSystemAsset.gray5.color
            ]
        )
        let attrString = NSMutableAttributedString()
        attrString.append(remainingString)
        attrString.append(timeString)
        label.attributedText = attrString
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var exampleStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                exampleRouteNumLabel,
                exampleArrivalInfoLabel
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = DesignSystemAsset.gray2.color
        stackView.layer.cornerRadius = 10
        return stackView
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
        [
            starImgView,
            messageLabel,
            exampleStackView,
            exampleLabel,
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            messageLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor
            ),
            
            starImgView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            starImgView.bottomAnchor.constraint(
                equalTo: messageLabel.topAnchor,
                constant: -30
            ),
            
            exampleStackView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            exampleStackView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: 0.8
            ),
            exampleStackView.heightAnchor.constraint(
                equalToConstant: 100
            ),
            exampleStackView.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: 30
            ),
            
            exampleLabel.centerYAnchor.constraint(
                equalTo: exampleStackView.topAnchor
            ),
            exampleLabel.centerXAnchor.constraint(
                equalTo: exampleStackView.leadingAnchor
            ),
        ])
        exampleStackView.addDivider(
            color: DesignSystemAsset.gray6.color,
            hasPadding: true,
            dividerRatio: 0.8
        )
    }
}
