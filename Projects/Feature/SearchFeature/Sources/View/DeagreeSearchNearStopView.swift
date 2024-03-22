//
//  DeagreeSearchNearStopView.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class DeagreeSearchNearStopView: UIButton {
    private let busStopImageView: UIImageView = {
        let symbolName = "pin.fill"

        var configuration = UIImage.SymbolConfiguration(
            pointSize: 35,
            weight: .bold
        )
        configuration = configuration.applying(
            UIImage.SymbolConfiguration(
                font: UIFont.systemFont(ofSize: 25, weight: .bold),
                scale: .default
            )
        )
        
        let pinImage = UIImage(
            systemName: symbolName,
            withConfiguration: configuration
        )?.withTintColor(.black)

        let pinImageView = UIImageView(image: pinImage)
        pinImageView.tintColor = .black

        return pinImageView
    }()

    private let nearStopLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(size: 16)
        label.textColor = .black
        label.text = "주변정류장"
        return label
    }()
    
    private let nearStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 14)
        label.textColor = DesignSystemAsset.gray6.color
        label.text = "아직 알 수 없어요"
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.lightRed.color
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        drawShadow()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(
        busStopName: String,
        distance: String
    ) {
        nearStopNameLabel.text = busStopName
        distanceLabel.text = distance
    }
    
    private func drawShadow() {
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
    }
    
    private func configureUI() {
        backgroundColor = UIColor.white
        
        [
            busStopImageView,
            nearStopLabel,
            nearStopNameLabel,
            distanceLabel,
        ]
            .forEach { components in
                addSubview(components)
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        NSLayoutConstraint.activate([
            busStopImageView.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            busStopImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 15
            ),
            
            nearStopLabel.leadingAnchor.constraint(
                equalTo: busStopImageView.trailingAnchor,
                constant: 20
            ),
            nearStopLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nearStopLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -3
            ),
            
            nearStopNameLabel.leadingAnchor.constraint(
                equalTo: nearStopLabel.leadingAnchor
            ),
            nearStopNameLabel.topAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 3
            ),
            nearStopNameLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20
            ),
            
            distanceLabel.bottomAnchor.constraint(
                equalTo: nearStopNameLabel.bottomAnchor
            ),
            distanceLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
        ])
    }
}
