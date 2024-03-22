//
//  RegularAlarmForBusTableViewCell.swift
//  BusStopFeature
//
//  Created by Jisoo HAM on 3/4/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

public final class RegularAlarmForBusTableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    public var busNumberLb: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 16)
        label.textColor = DesignSystemAsset.blueBus.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    private var nextStationLb: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 16)
        label.textColor = DesignSystemAsset.remainingColor.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    private var nextSymbol: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 16,
            weight: .regular
        )
        let img = UIImage(
            systemName: "chevron.right",
            withConfiguration: configuration
        )
        let image = UIImageView(image: img)
        image.tintColor = DesignSystemAsset.remainingColor.color
        return image
    }()
    
    public let clearBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.isHighlighted = true
        return button
    }()
    
    override public init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        [busNumberLb, nextStationLb]
            .forEach { $0.text = "" }

        disposeBag = DisposeBag()
    }
    
    public func updateUI(
        busNumber: String,
        nextStopName: String
    ) {
        busNumberLb.text = busNumber
        nextStationLb.text = nextStopName
    }
    
    private func configureUI() {
        [busNumberLb, nextStationLb, nextSymbol, clearBtn]
            .forEach { component in
                component.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(component)
            }
        
        NSLayoutConstraint.activate([
            clearBtn.widthAnchor.constraint(equalTo: widthAnchor),
            clearBtn.heightAnchor.constraint(equalToConstant: 60),
            clearBtn.topAnchor.constraint(equalTo: topAnchor),
            clearBtn.leadingAnchor.constraint(equalTo: leadingAnchor),
            busNumberLb.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nextStationLb.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            nextSymbol.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 20
            ),
            busNumberLb.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 30
            ),
            busNumberLb.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.27
            ),
            busNumberLb.trailingAnchor.constraint(
                equalTo: nextStationLb.leadingAnchor,
                constant: -10
            ),
            nextStationLb.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.55
            ),
            
            nextSymbol.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -30
            ),
        ])
        
    }
}
