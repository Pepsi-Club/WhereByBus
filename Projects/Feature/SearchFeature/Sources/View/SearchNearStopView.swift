//
//  SearchNearStopView.swift
//  SearchFeatureDemo
//
//  Created by 유하은 on 2024/02/05.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class SearchNearStopView: UIButton {
    private let totalStack1: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.alignment = .center
            stack.spacing = 20
            return stack
        }()
    
    private let totalStack2: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .leading
            stack.spacing = 5
            return stack
        }()
    
    private let totalStack3: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fill
            stack.alignment = .center
            stack.spacing = 180
            return stack
        }()
    
    private let busStopImageView: UIImageView = {
        let symbolName = "pin.fill"

        var configuration = UIImage.SymbolConfiguration(pointSize: 35,
                                                        weight: .bold)
        configuration = configuration.applying(UIImage.SymbolConfiguration(
            font: UIFont.systemFont(ofSize: 25, weight: .bold),
                            scale: .default))
        
        let pinImage = UIImage(
            systemName: symbolName,
            withConfiguration: configuration)?.withTintColor(.black)

        let pinImageView = UIImageView(image: pinImage)
        pinImageView.tintColor = .black

        return pinImageView
    }()

    private let nearStopLabel: UILabel = {
        let label = UILabel()
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
        label.text = "홍대입구역"
        
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 15)
        label.textColor = DesignSystemAsset.lightRed.color
        label.text = "200m"
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        [busStopImageView, nearStopLabel, nearStopNameLabel, distanceLabel,
         totalStack3, totalStack2, totalStack1]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [nearStopNameLabel, distanceLabel]
            .forEach { components in
                totalStack3.addArrangedSubview(components)
            }
        
        [nearStopLabel, totalStack3]
            .forEach { components in
                totalStack2.addArrangedSubview(components)
            }
        
        [busStopImageView, totalStack2]
            .forEach { components in
                totalStack1.addArrangedSubview(components)
            }

        addSubview(totalStack1)
        self.backgroundColor = UIColor.white

        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
        
        NSLayoutConstraint.activate([
            totalStack1.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            totalStack1.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 15
            ),
            totalStack1.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -20
            ),
        ])
    }
}
