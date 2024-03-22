//
//  BusStopCoordinator.swift
//  FeatureDependency
//
//  Created by Jisoo HAM on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol BusStopCoordinator: Coordinator {
    func busStopMapLocation(busStopId: String)
    func moveToRegualrAlarm()
}
