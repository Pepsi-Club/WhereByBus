//
//  CoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

public protocol CoreDataService {
    func fetch<T: CoreDataStorable>(type: T.Type) throws -> [T]
    
    func save(data: some CoreDataStorable) throws
    
    func update<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws
    
    func delete<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws
    
    func duplicationCheck<T: CoreDataStorable, U: Equatable>(
        type: T.Type,
        uniqueKeyPath: KeyPath<T, U>,
        uniqueValue: U
    ) throws -> Bool
}
