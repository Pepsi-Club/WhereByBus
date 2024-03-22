//
//  NearMapUseCase.swift
//  Domain
//
//  Created by Muker on 2/7/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift

public protocol NearMapUseCase {
    func requestAuthorize()
    func getNearByStopInfo(
    ) -> Observable<(BusStopInfoResponse, String)>
    func getSelectedBusStop(
        busStopId: String
    ) -> (BusStopInfoResponse, String)
    func getNearBusStopList(
        longitudeRange: ClosedRange<Double>,
        latitudeRange: ClosedRange<Double>
    ) -> [BusStopInfoResponse]
}
