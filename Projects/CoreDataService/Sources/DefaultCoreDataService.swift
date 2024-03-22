//
//  DefaultCoreDataService.swift
//  CoreDataService
//
//  Created by gnksbm on 2/17/24.
//  Copyright © 2024 GeonSeobKim. All rights reserved.
//

import Foundation

import Core

import CoreData

public final class DefaultCoreDataService: CoreDataService {
    private var container: NSPersistentContainer
    
    public init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetch<T: CoreDataStorable>(type: T.Type) throws -> [T] {
        do {
            return try fetchMO(type: type)
                .compactMap { $0 as? CoreDataModelObject }
                .compactMap { $0.toDomain as? T }
        } catch {
            throw error
        }
    }
    
    public func save<T: CoreDataStorable>(data: T) throws {
        let object = NSEntityDescription.insertNewObject(
            forEntityName: "\(type(of: data))MO",
            into: container.viewContext
        )
        let mirror = Mirror(reflecting: data)
        mirror.children.forEach { key, value in
            guard let key,
                  let propertyName = String(describing: key)
                .split(separator: ".")
                .last
            else { return }
            object.setValue(value, forKey: String(propertyName))
        }
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            throw error
        }
    }
    
    public func update<T: CoreDataStorable, U: Equatable>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        do {
            let fetchedMo = try fetchMO(type: type(of: data))
            let uniqueValue = data[keyPath: uniqueKeyPath]
            let object = fetchedMo.first { object in
                guard let fetchedValue = object.value(
                    forKey: uniqueKeyPath.propertyName
                ) as? U
                else { return false }
                return fetchedValue == uniqueValue
            }
            let mirror = Mirror(reflecting: data)
            mirror.children.forEach { key, value in
                guard let key,
                      let propertyName = String(describing: key)
                    .split(separator: ".")
                    .last
                else { return }
                object?.setValue(
                    value,
                    forKey: String(propertyName)
                )
            }
            if container.viewContext.hasChanges {
                do {
                    try container.viewContext.save()
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    public func delete<T: CoreDataStorable, U>(
        data: T,
        uniqueKeyPath: KeyPath<T, U>
    ) throws {
        do {
            let fetchedMo = try fetchMO(type: type(of: data))
            guard let object = fetchedMo.first(where: { object in
                object.value(forKey: uniqueKeyPath.propertyName) != nil
            })
            else { return }
            container.viewContext.delete(object)
            if container.viewContext.hasChanges {
                do {
                    try container.viewContext.save()
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    public func duplicationCheck<T: CoreDataStorable, U: Equatable>(
        type: T.Type,
        uniqueKeyPath: KeyPath<T, U>,
        uniqueValue: U
    ) throws -> Bool {
        do {
            let fetchedMO = try fetchMO(type: type)
            return fetchedMO.contains { object in
                guard let uniqueProperty = object.value(
                    forKey: uniqueKeyPath.propertyName
                ) as? U
                else { return false }
                return uniqueProperty == uniqueValue
            }
        } catch {
            throw error
        }
    }
    
    private func fetchMO<T: CoreDataStorable>(
        type: T.Type
    ) throws -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(
            entityName: "\(type)MO"
        )
        do {
            return try container.viewContext.fetch(request)
        } catch {
            throw error
        }
    }
}
