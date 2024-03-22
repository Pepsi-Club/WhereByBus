//
//  SettingAlarmViewCell.swift
//  SettingsFeature
//
//  Created by 유하은 on 2024/02/14.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

// MARK: 걱정,, 이렇게 짜면 rx 연결할때 개고생할거같아서 눈물남
final class SettingAlarmViewCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -8)
        ])

        addSquareView(withText: "1분 전")
        addSquareView(withText: "3분 전")
        addSquareView(withText: "5분 전")
        addSquareView(withText: "10분 전")
    }

    private func addSquareView(withText text: String) {
        
        let squareView = UIView()
    
        squareView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        squareView.layer.cornerRadius = 20
        squareView.backgroundColor = DesignSystemAsset.gray3.color
        squareView.translatesAutoresizingMaskIntoConstraints = false
       
        let label = UILabel()
        
        label.text = text
        label.textColor = DesignSystemAsset.gray5.color
        label.textAlignment = .center
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.light.font(size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        squareView.addSubview(label)
        
        NSLayoutConstraint.activate([
            squareView.widthAnchor.constraint(equalToConstant: 100),
            squareView.heightAnchor.constraint(equalToConstant: 40),
            
            label.leadingAnchor.constraint(equalTo: squareView.leadingAnchor,
                                           constant: 10),
            label.trailingAnchor.constraint(equalTo: squareView.trailingAnchor,
                                            constant: -10),
            label.topAnchor.constraint(equalTo: squareView.topAnchor,
                                       constant: 5),
            label.bottomAnchor.constraint(equalTo: squareView.bottomAnchor,
                                          constant: -5)
        ])

        stackView.addArrangedSubview(squareView)
    }
}
