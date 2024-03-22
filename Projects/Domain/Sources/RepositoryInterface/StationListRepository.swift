//
//  StationListRepository.swift
//  Domain
//
//  Created by 유하은 on 2024/02/27.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

public protocol StationListRepository {
    var stationList: BehaviorSubject<[BusStopInfoResponse]> { get }
    var recentlySearchedStation: BehaviorRelay<[BusStopInfoResponse]> { get }
    
    func saveRecentSearch(_ searchCell: BusStopInfoResponse)
    func removeRecentSearch()
    func getNearByStopInfo(
        startPointLocation: CLLocation
    ) -> (BusStopInfoResponse, String)
}
