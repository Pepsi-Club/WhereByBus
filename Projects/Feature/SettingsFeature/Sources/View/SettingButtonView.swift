//
//  SettingButtonView.swift
//  SettingsFeature
//
//  Created by Jisoo Ham on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

class SettingButtonView: UIView {
    
    public let basicAlarmSetting: SettingButton = {
        let view = SettingButton(
            iconName: "alarm",
            title: "알람 설정",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return view
    }()
    public lazy var developVersion: SettingButton = {
        let view = SettingButton(
            iconName: "exclamationmark.circle",
            title: "프로그램 정보",
            rightTitle: "v \(appVersion ?? "")",
            isHiddenArrowRight: true
        )
        return view
    }()
    public lazy var termsPrivacyBtn: SettingButton = {
        let view = SettingButton(
            iconName: "lock.shield",
            title: "서비스 이용약관",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return view
    }()
    public lazy var locationPrivacyBtn: SettingButton = {
        let btn = SettingButton(
            iconName: "location.circle",
            title: "개인정보처리방침",
            rightTitle: "",
            isHiddenArrowRight: false
        )
        return btn
    }()
    private var appVersion: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        return version
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [developVersion,
         termsPrivacyBtn, locationPrivacyBtn]
            .forEach { components in
                components.translatesAutoresizingMaskIntoConstraints = false
                components.heightAnchor.constraint(
                    equalToConstant: 30
                ).isActive = true
                addSubview(components)
            }
        
        NSLayoutConstraint.activate([
//            basicAlarmSetting.topAnchor.constraint(
//                equalTo: topAnchor
//            ),
//            basicAlarmSetting.leadingAnchor.constraint(
//                equalTo: leadingAnchor
//            ),
//            basicAlarmSetting.trailingAnchor.constraint(
//                equalTo: trailingAnchor
//            ),
//            basicAlarmSetting.widthAnchor.constraint(
//                equalTo: widthAnchor
//            ),
//            termsPrivacyBtn.topAnchor.constraint(
//                equalTo: basicAlarmSetting.bottomAnchor,
//                constant: 20
//            ),
            termsPrivacyBtn.topAnchor.constraint(
                equalTo: topAnchor
            ),
            termsPrivacyBtn.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            termsPrivacyBtn.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            termsPrivacyBtn.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            locationPrivacyBtn.topAnchor.constraint(
                equalTo: termsPrivacyBtn.bottomAnchor,
                constant: 20
            ),
            locationPrivacyBtn.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            locationPrivacyBtn.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            locationPrivacyBtn.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            developVersion.topAnchor.constraint(
                equalTo: locationPrivacyBtn.bottomAnchor,
                constant: 20
            ),
            developVersion.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            developVersion.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            developVersion.widthAnchor.constraint(
                equalTo: widthAnchor
            ),
            
        ])
    }
    
}
