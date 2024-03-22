//
//  SearchTVRecentSearchBGView.swift
//  SearchFeature
//
//  Created by gnksbm on 3/15/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class SearchTVRecentSearchBGView: UIView {
    let descriptionLabel: UILabel = {
        let label = UILabel()
        let font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 14
        )
        label.font = font
        label.textAlignment = .center
        label.textColor = DesignSystemAsset.gray5.color
        label.text = "최근 검색된 정류장이 없습니다."
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
        [descriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
