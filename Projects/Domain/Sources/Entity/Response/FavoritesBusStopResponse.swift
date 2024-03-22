//
//  FavoritesBusStopResponse.swift
//  Domain
//
//  Created by gnksbm on 2/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct FavoritesBusStopResponse: CoreDataStorable {
    public let busStopId: String
    public var busIds: [String]
    
    public init(
        busStopId: String,
        busIds: [String]
    ) {
        self.busStopId = busStopId
        self.busIds = busIds
    }
}
