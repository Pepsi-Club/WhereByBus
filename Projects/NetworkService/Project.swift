import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "NetworkService",
    moduleType: .dynamicFramework,
    dependencies: [
        .domain,
    ]
)
