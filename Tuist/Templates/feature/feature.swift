//
//  Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by gnksbm on 2023/11/20.
//

import ProjectDescription

private let nameAttribute = Template.Attribute.required("name")

private let template = Template(
    description: "Feature 모듈 템플릿",
    attributes: [
        nameAttribute,
    ],
    items: [
        // MARK: Project.swift
        .file(path: projectPath(with: "Project.swift"), templatePath: "project.stencil"),
        // MARK: DemoAppDelegate.swift, DemoSceneDelegate.swift
        .file(path: projectPath(with: "Demo/AppDelegate.swift"), templatePath: "appDelegate.stencil"),
        .file(path: projectPath(with: "Demo/SceneDelegate.swift"), templatePath: "sceneDelegate.stencil"),
        // MARK: Coordinator, ViewController, ViewModel
        .file(path: projectPath(with: "Sources/ViewModel/\(nameAttribute)ViewModel.swift"), templatePath: "viewModel.stencil"),
        .file(path: projectPath(with: "Sources/ViewController/\(nameAttribute)ViewController.swift"), templatePath: "viewContoller.stencil"),
//        .file(path: projectPath(with: "Sources/Coordinator/\(nameAttribute)Coordinator.swift"), templatePath: "coordinator.stencil"),
        .file(path: projectPath(with: "Sources/Coordinator/Dafault\(nameAttribute)Coordinator.swift"), templatePath: "defaultCoordinator.stencil"),
        // MARK: FeatureDependency Coordinator Protocol
        .file(path: "Projects/FeatureDependency/Sources/Coordinator/\(nameAttribute)Coordinator.swift", templatePath: "coordinator.stencil"),
        // MARK: UnitTests
//        .file(path: projectPath(with: "Tests/\(nameAttribute)FeatureTests.swift"), templatePath: "tests.stencil"),
    ]
)

private func projectPath(with name: String) -> String {
    "Projects/Feature/\(nameAttribute)Feature/\(name)"
}
