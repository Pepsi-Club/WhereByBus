//
//  HomeCoordinator.swift
//  FeatureDependency
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public protocol HomeCoordinator: Coordinator {
    func updateFavoritesState(isEmpty: Bool)
    func startSearchFlow()
    func startBusStopFlow(stationId: String)
}
