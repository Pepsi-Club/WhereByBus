//
//  DefaultCoordinatorProvider.swift
//  App
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UIKit

import FeatureDependency
import HomeFeature
import SearchFeature
import AlarmFeature
import BusStopFeature
import NearMapFeature
import Domain

final class DefaultCoordinatorProvider: CoordinatorProvider {
    func makeHomeCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController
    ) -> HomeCoordinator {
        DefaultHomeCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self
        )
    }
    
    func makeBusStopCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        busStopId: String,
        flow: FlowState
    ) -> BusStopCoordinator {
        DefaultBusStopCoordinator(
            parent: parent,
            navigationController: navigationController,
            busStopId: busStopId,
            coordinatorProvider: self,
            flow: flow
        )
    }
    
    func makeSearchCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> SearchCoordinator {
        DefaultSearchCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: flow
        )
    }
    
    func makeAddRegularAlarmCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState
    ) -> AddRegularAlarmCoordinator {
        DefaultAddRegularAlarmCoordinator(
            parent: parent,
            navigationController: navigationController,
            coordinatorProvider: self,
            flow: .fromAlarm
        )
    }
    
    func makeNearMapCoordinator(
        parent: Coordinator,
        navigationController: UINavigationController,
        flow: FlowState,
        busStopId: String?
    ) -> NearMapCoordinator {
        DefaultNearMapCoordinator(
            parent: parent,
			navigationController: navigationController,
            coordinatorProvider: self,
            flow: flow, 
            busStopId: busStopId
        )
    }
}
