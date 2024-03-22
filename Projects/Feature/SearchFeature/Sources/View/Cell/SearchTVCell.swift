//
//  RecentSearchCell.swift
//  SearchFeature
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

import RxSwift

final class SearchTVCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    private let busStopNameLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 16)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 13)
        label.textAlignment = .left
        label.textColor = DesignSystemAsset.gray5.color
        return label
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [busStopNameLabel, descriptionLabel].forEach {
            $0.text = nil
        }
        disposeBag = .init()
    }
    
    public func updateUI(response: BusStopInfoResponse) {
        busStopNameLabel.text = response.busStopName
        let description = "\(response.busStopId) | \(response.direction) 방면"
        descriptionLabel.text = description
    }
    
    private func configureUI() {
        [busStopNameLabel, descriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            busStopNameLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),
            busStopNameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 15
            ),
            busStopNameLabel.bottomAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -3
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: centerYAnchor,
                constant: 3
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: busStopNameLabel.leadingAnchor
            ),
            descriptionLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -15
            ),
        ])
    }
}
