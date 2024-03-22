//
//  Scheme.swift
//  EnvironmentPlugin
//
//  Created by gnksbm on 2024/01/13.
//

import ProjectDescription

public extension Scheme {
    static func moduleScheme(name: String) -> Self {
        Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: "Debug",
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["\(name)"]
                )
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug"),
            profileAction: .profileAction(configuration: "Debug"),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    }
    
    static func uiTestsScheme(name: String) -> Self {
        Scheme(
            name: "\(name)UITests",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)UITests"],
                configuration: "Debug",
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["\(name)UITests"]
                )
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug"),
            profileAction: .profileAction(configuration: "Debug"),
            analyzeAction: .analyzeAction(configuration: "Debug")
        )
    }
}
