//
//  NearMapCoordinator.swift
//  FeatureDependency
//
//  Created by Muker on 2/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol NearMapCoordinator: Coordinator {
    func startBusStopFlow(busStopId: String)
}
