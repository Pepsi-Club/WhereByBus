//
//  BusTableViewCell.swift
//  BusStopFeatureDemo
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import DesignSystem

import RxSwift

public final class BusTableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    private let firstArrivalInfoView = ArrivalInfoView()
    private let secondArrivalInfoView = ArrivalInfoView()
    public let starBtnTapEvent = PublishSubject<Void>()
    public let alarmBtnTapEvent = PublishSubject<Void>()
    
    private lazy var starBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 15,
            bottom: 10,
            trailing: 5
        )
        let imgConfig = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 13)
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let btn = UIButton(configuration: config)
        return btn
    }()
    
    private lazy var alarmBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        let imgConfig = UIImage.SymbolConfiguration(
            pointSize: 12
        )
        config.preferredSymbolConfigurationForImage = imgConfig
        config.baseForegroundColor = DesignSystemAsset.mainColor.color
        let btn = UIButton(configuration: config)
        btn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btn.isHidden = true
        return btn
    }()
    
    public let busNumber: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .bold.font(size: 18)
        label.textColor = DesignSystemAsset.blueBus.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    private let nextStopName: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF
            .regular.font(size: 14)
        label.textColor = DesignSystemAsset.remainingColor.color
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        configureUI()
        buttonTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateBtn(
        favorite: Bool,
        alarm: Bool
    ) {
        changeFavBtnColor(isFavoriteOn: favorite)
        changeAlarmBtnColor(isAlarmOn: alarm)
    }
    
    public func updateBusRoute(
        routeName: String,
        nextRouteName: String
    ) {
        busNumber.text = routeName
        nextStopName.text = nextRouteName + " 방면"
    }
    
    public func updateFirstArrival(
        firstArrivalTime: String,
        firstArrivalRemaining: String
    ) {
        firstArrivalInfoView.updateUI(
            time: firstArrivalTime, remainingStops: firstArrivalRemaining
        )
    }
    
    public func updateSecondArrival(
        secondArrivalTime: String,
        secondArrivalRemaining: String
    ) {
        secondArrivalInfoView.updateUI(
            time: secondArrivalTime, remainingStops: secondArrivalRemaining
        )
    }
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        [busNumber, nextStopName].forEach {
            $0.text = nil
        }
        [firstArrivalInfoView, secondArrivalInfoView].forEach {
            $0.prepareForReuse()
        }
        
        disposeBag = DisposeBag()
        buttonTap()
    }
    
    private func buttonTap() {
        starBtn.rx.tap
            .map({ _ in })
            .withUnretained(self)
            .subscribe(onNext: { cell, _ in
                cell.starBtnTapEvent.onNext(())
            })
            .disposed(by: disposeBag)
        
//        alarmBtn.rx.tap
//            .map({ _ in
//            })
//            .withUnretained(self)
//            .subscribe(onNext: { cell, _ in
//                cell.alarmBtnTapEvent.onNext(())
//            })
//            .disposed(by: disposeBag)
    }
    
    private func changeFavBtnColor(isFavoriteOn: Bool) {
        
        guard var config = starBtn.configuration
        else { return }
        
        config.image = isFavoriteOn
        ? UIImage(systemName: "star.fill")
        : UIImage(systemName: "star")
        
        config.baseForegroundColor
        = isFavoriteOn
        ? DesignSystemAsset.carrotOrange.color
        : DesignSystemAsset.mainColor.color
        
        starBtn.configuration = config
    }
    
    private func changeAlarmBtnColor(isAlarmOn: Bool) {
        guard var config = alarmBtn.configuration
        else { return }
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 10
        )
        
        config.image = isAlarmOn
        ? UIImage(systemName: "alarm.waves.left.and.right.fill")
        : UIImage(systemName: "alarm")
        
        config.baseForegroundColor = isAlarmOn
        ? DesignSystemAsset.carrotOrange.color
        : DesignSystemAsset.mainColor.color
        
        alarmBtn.configuration = config
    }
}

extension BusTableViewCell {
    private func configureUI() {
        
        [starBtn, busNumber, nextStopName,
         firstArrivalInfoView, secondArrivalInfoView, alarmBtn]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(components)
            }
        
        NSLayoutConstraint.activate([
            starBtn.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),
            starBtn.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            busNumber.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 12
            ),
            busNumber.leadingAnchor.constraint(
                equalTo: starBtn.trailingAnchor,
                constant: 10
            ),
            busNumber.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.38
            ),
            
            nextStopName.topAnchor.constraint(
                equalTo: busNumber.bottomAnchor,
                constant: 8
            ),
            nextStopName.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
            nextStopName.leadingAnchor.constraint(
                equalTo: starBtn.trailingAnchor,
                constant: 10
            ),
            nextStopName.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.38
            ),
            
            firstArrivalInfoView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            firstArrivalInfoView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
            firstArrivalInfoView.leadingAnchor.constraint(
                equalTo: nextStopName.trailingAnchor,
                constant: 10
            ),
            firstArrivalInfoView.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.17
            ),
            
            secondArrivalInfoView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            secondArrivalInfoView.leadingAnchor.constraint(
                equalTo: firstArrivalInfoView.trailingAnchor,
                constant: 10
            ),
            secondArrivalInfoView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            ),
            secondArrivalInfoView.widthAnchor.constraint(
                equalToConstant: contentView.frame.width * 0.17
            ),
            
            alarmBtn.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 15
            ),
            alarmBtn.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10
            ),
            
        ])
        
    }
}
