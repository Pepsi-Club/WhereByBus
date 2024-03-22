//
//  FavoritesBusStopResponseMO+CoreDataClass.swift
//  
//
//  Created by gnksbm on 2/25/24.
//
//

import Foundation
import CoreData

import Core
import Domain

@objc(FavoritesBusStopResponseMO)
public class FavoritesBusStopResponseMO: NSManagedObject, CoreDataModelObject {
    public var toDomain: CoreDataStorable {
        guard let busStopId,
              let busIds
        else { fatalError() }
        return FavoritesBusStopResponse(
            busStopId: busStopId,
            busIds: busIds
        )
    }
}
