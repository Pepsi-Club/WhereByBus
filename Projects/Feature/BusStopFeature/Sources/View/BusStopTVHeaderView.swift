//
//  BusStopHeaderView.swift
//  BusStopFeatureDemo
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

final class BusStopTVHeaderView: UITableViewHeaderFooterView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily
            .NanumSquareNeoOTF.regular.font(size: 16.0)
        label.textColor = DesignSystemAsset.settingColor.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(with title: String) {
        titleLabel.text = title
    }
    
    private func configureUI() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            )
        ])
    }
}
