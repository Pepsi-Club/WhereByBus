import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeProject(
    name: "CoreDataService",
    moduleType: .dynamicFramework,
    dependencies: [
        .domain
    ]
)
