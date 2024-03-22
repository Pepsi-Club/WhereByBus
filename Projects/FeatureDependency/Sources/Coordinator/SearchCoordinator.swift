//
//  SearchCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import Domain

public protocol SearchCoordinator: Coordinator {
    func startBusStopFlow(stationId: String)
    func startNearMapFlow()
//    func finishFlow()
}
