//
//  FavoritesBusStopResponseMO+CoreDataProperties.swift
//  
//
//  Created by gnksbm on 3/4/24.
//
//

import Foundation
import CoreData

extension FavoritesBusStopResponseMO {
    @nonobjc public class func fetchRequest(
    ) -> NSFetchRequest<FavoritesBusStopResponseMO> {
        return NSFetchRequest<FavoritesBusStopResponseMO>(
            entityName: "FavoritesBusStopResponseMO"
        )
    }

    @NSManaged public var busIds: [String]?
    @NSManaged public var busStopId: String?
}
