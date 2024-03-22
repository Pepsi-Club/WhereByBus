//
//  ArrivalInfoView.swift
//  HomeFeature
//
//  Created by gnksbm on 1/24/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

public final class ArrivalInfoView: UIStackView {
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.bold.font(
            size: 14
        )
        label.textColor = DesignSystemAsset.routeTimeColor.color
        return label
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.light.font(
            size: 12
        )
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = DesignSystemAsset.gray6.color
        return label
    }()
    
    public init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addArrangedSubview(timeLabel)
        axis = .vertical
        alignment = .leading
        spacing = 6
    }
    
    public func prepareForReuse() {
        timeLabel.text = nil
        remainingLabel.text = nil
    }
    
    public func updateUI(
        time: String,
        remainingStops: String
    ) {
        let routeTimeColor = DesignSystemAsset.routeTimeColor.color
        let carrotOrange = DesignSystemAsset.carrotOrange.color
        if time.contains(where: { Int(String($0)) != nil }) {
            timeLabel.text = time
            timeLabel.textColor = routeTimeColor
            addArrangedSubview(remainingLabel)
            remainingLabel.text = remainingStops
        } else {
            timeLabel.text = time
            timeLabel.textColor = carrotOrange
            removeArrangedSubview(remainingLabel)
        }
    }
}
