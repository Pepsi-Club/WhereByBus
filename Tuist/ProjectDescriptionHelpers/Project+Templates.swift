//
//  Project+Templates.swift
//  Config
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

import ProjectDescription
import EnvironmentPlugin
import DependencyPlugin

extension Project {
    // MARK: Refact
    public static func makeProject(
        name: String,
        moduleType: ModuleType,
        entitlementsPath: Path? = nil,
        isTestable: Bool = false,
        hasResource: Bool = false,
        appExtensionTarget: [Target] = [],
        packages: [Package] = [],
        dependencies: [TargetDependency],
        coreDataModel: [CoreDataModel] = []
    ) -> Self {
        var schemes = [Scheme]()
        var targets = [Target]()
        var targetModule: Target
        var entitlements: Entitlements?
        if let entitlementsPath {
            entitlements = .file(path: entitlementsPath)
        }
        switch moduleType {
        case .app:
            targetModule = appTarget(
                name: name,
                entitlements: entitlements,
                dependencies: dependencies + appExtensionTarget.map {
                    TargetDependency.target(name: $0.name)
                }
            )
            let uiTestsTarget = uiTestTarget(
                name: name,
                dependencies: [.target(targetModule)]
            )
            targets.append(uiTestsTarget)
            appExtensionTarget.forEach {
                targets.append($0)
            }
            schemes.append(.moduleScheme(name: name))
            schemes.append(.uiTestsScheme(name: name))
        case .dynamicFramework, .staticFramework:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                productType: moduleType.product,
                dependencies: dependencies,
                coreDataModel: coreDataModel
            )
        case .feature:
            targetModule = frameworkTarget(
                name: name,
                entitlements: entitlements,
                hasResource: hasResource,
                productType: moduleType.product,
                isPresentation: true,
                dependencies: dependencies,
                coreDataModel: coreDataModel
            )
//            let demoTarget = demoAppTarget(
//                name: name,
//                dependencies: [.target(targetModule)]
//            )
//            targets.append(demoTarget)
//            schemes.append(.moduleScheme(name: demoTarget.name))
        }
        targets.append(targetModule)
//        if isTestable {
//            let test = unitTestTarget(
//                name: name,
//                dependencies: [.target(targetModule)]
//            )
//            targets.append(test)
//        }
        return Project(
            name: name,
            organizationName: .organizationName,
            packages: packages,
            targets: targets,
            schemes: schemes
        )
    }
    
    private static func appTarget(
        name: String,
        entitlements: Entitlements?,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: .bundleID,
            deploymentTarget: .deploymentTarget,
            infoPlist: .appInfoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: entitlements,
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: .appDebug
        )
    }

    private static func demoAppTarget(
        name: String,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: "\(name)Demo",
            platform: .iOS,
            product: .app,
            bundleId: "\(String.bundleID).\(name)Demo",
            deploymentTarget: .deploymentTarget,
            infoPlist: .demoAppInfoPlist(name: name),
            sources: [
                "Demo/**",
            ],
            entitlements: entitlements,
            scripts: [.featureSwiftLint],
            dependencies: dependencies,
            settings: .appDebug
        )
    }

    private static func frameworkTarget(
        name: String,
        entitlements: Entitlements?,
        hasResource: Bool,
        productType: Product,
        isPresentation: Bool = false,
        dependencies: [TargetDependency],
        coreDataModel: [CoreDataModel]
    ) -> Target {
        let scripts: [TargetScript] = isPresentation ?
        [.featureSwiftLint] : [.swiftLint]
        return Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: .bundleID + ".\(name)",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Sources/**"],
            resources: hasResource ? ["Resources/**"] : nil,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            coreDataModels: coreDataModel
        )
    }
    
    public static func appExtensionTarget(
        name: String,
        plist: InfoPlist?,
        entitlements: Entitlements? = nil,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target(
            name: name,
            platform: .iOS,
            product: .appExtension,
            bundleId: .bundleID + ".\(name)",
            deploymentTarget: .deploymentTarget,
            infoPlist: plist,
            sources: ["\(name)/**"],
            entitlements: entitlements,
            scripts: [.swiftLint],
            dependencies: dependencies,
            settings: .settings(
                base: .init()
                    .setCodeSignManual()
                    .setProvisioning(),
                configurations: [
                    .debug(
                        name: .debug,
                        xcconfig: .relativeToRoot("XCConfig/\(name)_Debug.xcconfig")
                    ),
                    .release(
                        name: .release,
                        xcconfig: .relativeToRoot("XCConfig/\(name)_Release.xcconfig")
                    ),
                ]
            )
        )
    }
    
    private static func unitTestTarget(
        name: String,
        isFeature: Bool = false,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: "\(name)Tests",
            platform: .iOS,
            product: .unitTests,
            bundleId: .bundleID + ".\(name)Test",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Tests/**"],
            scripts: isFeature ? [.featureSwiftLint] : [.swiftLint],
            dependencies: dependencies,
            settings: .test
        )
    }
    
    private static func uiTestTarget(
        name: String,
        isFeature: Bool = false,
        dependencies: [TargetDependency]
    ) -> Target {
        Target(
            name: "\(name)UITests",
            platform: .iOS,
            product: .uiTests,
            bundleId: .bundleID + ".\(name)UITest",
            deploymentTarget: .deploymentTarget,
            infoPlist: .frameworkInfoPlist,
            sources: ["Tests/**"],
            scripts: isFeature ? [.featureSwiftLint] : [.swiftLint],
            dependencies: dependencies,
            settings: .test
        )
    }
}
