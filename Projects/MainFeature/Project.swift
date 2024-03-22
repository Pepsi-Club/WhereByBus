import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "MainFeature",
    moduleType: .dynamicFramework,
    dependencies: .Presentation.allCases.map { $0.dependency }
)
