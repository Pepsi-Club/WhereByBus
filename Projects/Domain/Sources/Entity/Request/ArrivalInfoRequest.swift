//
//  ArrivalInfoRequest.swift
//  Domain
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct ArrivalInfoRequest {
    public let busStopId: String
    
    public init(
        busStopId: String
    ) {
        self.busStopId = busStopId
    }
}
