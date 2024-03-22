//
//  AlarmSettingViewController.swift
//  SettingsFeature
//
//  Created by 유하은 on 2024/02/14.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//
import UIKit

import DesignSystem

import RxSwift

public final class AlarmSettingViewController: UIViewController {
    
    private let viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    private let settingAlarmViewCell = SettingAlarmViewCell()
    
    // 알람뷰셀과 timeLabel 스택
    private let alarmStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    
    // alarmSettingLabel 1 & 2 의 스택
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    private let labelStack2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 0
        return stack
    }()
    
    // labelStack과 busImg의 스택
    private let labelImgStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill 
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(
            size: 18
        )
        label.textColor =
            DesignSystemAsset.gray6.color
        
        return label
    }()
    
    private let alarmSettingLabel: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.extraBold.font(size: 24)
        label.text = "버스 도착 알림"
        return label
    }()
    
    private let alarmSettingLabel2: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 22)
        label.text = "을"
        return label
    }()
    
    private let alarmSettingLabel3: UILabel = {
        let label = UILabel()
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 19)
        label.text = "몇 분 전에 울릴까요?"
        return label
    }()
    
    private let busIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.bus2.image
        return imageView
    }()
    
    private let squareView: UIView = {
        let squareView = UIView()
        
        squareView.layer.cornerRadius = 30
        squareView.backgroundColor = DesignSystemAsset.gray6.color
        
        return squareView
    }()
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.textColor = .white
        label.textAlignment = .center
        label.font =
        DesignSystemFontFamily.NanumSquareNeoOTF.regular.font(size: 18)
        
        return label
    }()
    
        required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        [settingAlarmViewCell, alarmStack, labelStack, labelStack2,
         labelImgStack, timeLabel, alarmSettingLabel, alarmSettingLabel2,
         alarmSettingLabel3, busIconView, squareView, endLabel]
            .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [alarmSettingLabel, alarmSettingLabel2]
                    .forEach { components in
                        labelStack
                            .addArrangedSubview(components)
                    }
        
        [labelStack, alarmSettingLabel3]
                    .forEach { components in
                        labelStack2
                            .addArrangedSubview(components)
                    }
        
        [labelStack2, busIconView]
            .forEach { components in
                labelImgStack
                    .addArrangedSubview(components)
                }
        
        [settingAlarmViewCell, timeLabel]
                    .forEach { components in
                        alarmStack
                            .addArrangedSubview(components)
                    }
        
        NSLayoutConstraint.activate([
            
            // MARK: 굳이 없어도 되는 오토레이아웃이 있는가? 얘를 들어 labelStack
//            labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
//                                                constant: 50),
//            labelStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                                 constant: 50),
//            labelStack.topAnchor.constraint(
//                    equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20
//            ),
            squareView.widthAnchor.constraint(equalToConstant: 195),
            squareView.heightAnchor.constraint(equalToConstant: 56),
            squareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            squareView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                               constant: -20),
            
            endLabel.leadingAnchor.constraint(equalTo: squareView.leadingAnchor,
                                           constant: 10),
            endLabel.trailingAnchor.constraint(
                                            equalTo: squareView.trailingAnchor,
                                            constant: -10),
            endLabel.topAnchor.constraint(equalTo: squareView.topAnchor,
                                       constant: 5),
            endLabel.bottomAnchor.constraint(equalTo: squareView.bottomAnchor,
                                          constant: -5),
            // MARK: 왜 이새끼는,,,글씨 주제에 크기가 정해져 있으면서 width를 필요로 할까?
            endLabel.widthAnchor.constraint(equalToConstant: 195),
            
            labelImgStack.centerXAnchor.constraint(
                    equalTo: view.centerXAnchor
            ),
            labelImgStack.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: 30
            ),
            
            alarmStack.topAnchor.constraint(equalTo: labelImgStack.bottomAnchor,
                                            constant: 30),
            alarmStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            ])
        
}
            }
