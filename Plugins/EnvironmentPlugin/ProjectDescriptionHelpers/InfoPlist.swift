//
//  InfoPlist.swift
//  AppStore
//
//  Created by gnksbm on 2023/11/19.
//  Copyright © 2023 https://github.com/gnksbm/Clone_AppStore. All rights reserved.
//

import ProjectDescription

public extension InfoPlist {
    static let appInfoPlist: Self = .extendingDefault(
        with: .baseInfoPlist
            .merging(.additionalInfoPlist) { oldValue, newValue in
                newValue
            }
            .merging(.secrets) { oldValue, newValue in
                newValue
            }
    )
    
    static func demoAppInfoPlist(name: String) -> Self {
        .extendingDefault(
            with: .baseInfoPlist
                .merging(.additionalInfoPlist) { oldValue, newValue in
                    newValue
                }
                .merging(.secrets) { oldValue, newValue in
                    newValue
                }
                .merging([
                    "CFBundleDisplayName": "\(name)"
                ]) { oldValue, newValue in
                    newValue
                }
        )
    }
    
    static let frameworkInfoPlist: Self = .extendingDefault(
        with: .framework
            .merging(.secrets) { oldValue, newValue in
                newValue
            }
    )
}

public extension [String: Plist.Value] {
    static let secrets: Self = [
        "DATA_GO_KR_API_KEY": "$(DATA_GO_KR_API_KEY)",
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "KAKAO_PHASE": "alpha",
        "TERMS_OF_PRIVACY_URL": "$(TERMS_OF_PRIVACY_URL)",
        "LOCATION_PRIVACY_URL": "$(LOCATION_PRIVACY_URL)"
    ]
    
    static let additionalInfoPlist: Self = [
        "FirebaseAppDelegateProxyEnabled": false,
        "ITSAppUsesNonExemptEncryption": "NO",
        "NSAppTransportSecurity": [
            "NSExceptionDomains": [
                "ws.bus.go.kr": [
                    "NSIncludesSubdomains": true,
                    "NSExceptionAllowsInsecureHTTPLoads": true,
                ]
            ]
        ],
        "UIBackgroundModes": [
            "fetch",
            "processing",
            "remote-notification"
        ],
        "BGTaskSchedulerPermittedIdentifiers" : [.string(.bundleID)],
        "NSLocationWhenInUseUsageDescription" : "주변 정류장을 찾기 위해 권한이 필요합니다.",
        "NSLocationAlwaysAndWhenInUseUsageDescription" : "주변 정류장을 찾기 위해 권한이 필요합니다."
    ]
    
    static let baseInfoPlist: Self = [
        "CFBundleDisplayName": .bundleDisplayName,
        "CFBundleShortVersionString": .bundleShortVersionString,
        "CFBundleVersion": .bundleVersion,
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    ]
    
    static let notificationInfoPlist: Self = [
        "DATA_GO_KR_API_KEY": "$(DATA_GO_KR_API_KEY)",
        "CFBundleShortVersionString": .bundleShortVersionString,
        "CFBundleVersion": .bundleVersion,
        "CFBundleDisplayName": "$(PRODUCT_NAME)",
        "NSExtension": [
            "NSExtensionPointIdentifier": "com.apple.usernotifications.service",
            "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).NotificationService"
        ],
        "NSAppTransportSecurity": [
            "NSExceptionDomains": [
                "ws.bus.go.kr": [
                    "NSIncludesSubdomains": true,
                    "NSExceptionAllowsInsecureHTTPLoads": true,
                ]
            ]
        ],
    ]
    
    static let framework: Self = [
        "CFBundleDevelopmentRegion": "$(DEVELOPMENT_LANGUAGE)",
        "CFBundleExecutable": "$(EXECUTABLE_NAME)",
        "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
        "CFBundleInfoDictionaryVersion": "6.0",
        "CFBundleName": "$(PRODUCT_NAME)",
        "CFBundlePackageType": "FMWK",
        "CFBundleShortVersionString": .bundleShortVersionString,
        "CFBundleVersion": .bundleVersion,
    ]
}
