//
//  Dependency+ThirdPartyExternal.swift
//  DependencyPlugin
//
//  Created by gnksbm on 2023/12/27.
//

import ProjectDescription

public extension Array<TargetDependency> {
    enum ThirdPartyExternal: String, CaseIterable {
        case rxCocoa
        
        public var name: String {
            var name = rawValue.map { $0 }
            name.removeFirst()
            name.insert(Character(rawValue.first!.uppercased()), at: 0)
            return "\(String(name))"
        }
    }
}
