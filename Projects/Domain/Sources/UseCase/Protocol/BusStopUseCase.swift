//
//  BusStopUseCase.swift
//  Domain
//
//  Created by Jisoo HAM on 2/5/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol BusStopUseCase {
    var busStopSection
    : PublishSubject<BusStopArrivalInfoResponse> { get }
    var favorites: BehaviorSubject<[FavoritesBusStopResponse]> { get }
    
    func fetchBusArrivals(request: ArrivalInfoRequest)
    func handleFavorites(busStop: String, bus: BusArrivalInfoResponse)
    func update(
        busStopInfo: BusStopArrivalInfoResponse,
        busInfo: BusArrivalInfoResponse
    )
}
