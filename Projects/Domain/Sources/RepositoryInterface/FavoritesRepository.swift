//
//  FavoritesRepository.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol FavoritesRepository {
    var favorites: BehaviorSubject<[FavoritesBusStopResponse]> { get }
    
    func addRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) throws
    
    func removeRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) throws
}
