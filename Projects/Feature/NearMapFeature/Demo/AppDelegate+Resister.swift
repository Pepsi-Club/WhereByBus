//
//  AppDelegate+Resister.swift
//  NearMapFeatureDemo
//
//  Created by Muker on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

extension AppDelegate {
	func register() {
        DIContainer.register(
            type: NearMapUseCase.self,
            DefaultNearMapUseCase(
                stationListRepository: MockStationLIstRepository(), 
                locationService: MockLocationService()
            )
        )
	}
}
