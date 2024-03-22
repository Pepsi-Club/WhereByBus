//
//  Dependency+Module.swift
//  Environment
//
//  Created by gnksbm on 2023/11/19.
//

import ProjectDescription

public extension TargetDependency {
    static let app: Self = .module(name: "App")
    static let mainFeature: Self = .module(name: "MainFeature")
    static let featureDependency: Self = .module(name: "FeatureDependency")
    static let core: Self = .module(name: "Core")
    static let data: Self = .module(name: "Data")
    static let domain: Self = .module(name: "Domain")
    static let networkService: Self = .module(name: "NetworkService")
    static let coreDataService: Self = .module(name: "CoreDataService")
    static let designSystem: Self = .module(name: "DesignSystem")
    static let thirdPartyLibs: Self = .module(name: "ThirdPartyLibs")
    
    private static func module(name: String) -> Self {
        .project(target: name, path: .relativeToRoot("Projects/\(name)"))
    }
    private static func moduleWithAdditionalPath(name: String, path: String) -> Self {
        .project(target: name, path: .relativeToRoot("Projects/\(path)/\(name)"))
    }
}
