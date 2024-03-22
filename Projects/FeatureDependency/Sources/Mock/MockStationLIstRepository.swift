//
//  MockStationLIstRepository.swift
//  FeatureDependency
//
//  Created by 유하은 on 2024/03/07.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

import Domain

#if DEBUG
public final class MockStationLIstRepository: StationListRepository {
    public let stationList = BehaviorSubject<[BusStopInfoResponse]>(value: [])
    public let recentlySearchedStation
    = BehaviorRelay<[BusStopInfoResponse]>(value: [])
    
    public init(){ }
    
    public func saveRecentSearch(_ searchCell: BusStopInfoResponse) {
        
    }
    
    public func removeRecentSearch() {
        
    }
    
    public func getNearByStop(
        startPointLocation: CLLocation
    ) -> BusStopInfoResponse {
        return (
            BusStopInfoResponse(
                busStopName: "관현사입구",
                busStopId: "22320",
                direction: "새쟁이마을",
                longitude: "127.0632387636",
                latitude: "37.4373210738"
            )
        )
    }
    
    public func getNearByStopInfo(
        startPointLocation: CLLocation
    ) -> (BusStopInfoResponse, String) {
        return (
            BusStopInfoResponse(
                busStopName: "관현사입구",
                busStopId: "22320",
                direction: "새쟁이마을",
                longitude: "127.0632387636",
                latitude: "37.4373210738"
            ),
            ""
        )
    }
    
    private func fetchStationList() {
        Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: false
        ) { [weak self] _ in
            self?.stationList.onNext(
                [
                    BusStopInfoResponse(
                        busStopName: "관현사입구",
                        busStopId: "22320",
                        direction: "새쟁이마을",
                        longitude: "127.0632387636",
                        latitude: "37.4373210738"
                    ),
                    BusStopInfoResponse(
                        busStopName: "관현사입구",
                        busStopId: "22321",
                        direction: "청계산.원터골",
                        longitude: "127.063704",
                        latitude: "37.437154"
                    ),
                    BusStopInfoResponse(
                        busStopName: "새쟁이마을",
                        busStopId: "22322",
                        direction: "옛골",
                        longitude: "127.066179",
                        latitude: "37.434511"
                    ),
                    BusStopInfoResponse(
                        busStopName: "새쟁이마을",
                        busStopId: "22323",
                        direction: "관현사입구",
                        longitude: "127.0660515509",
                        latitude: "37.4347964213"
                    ),
                    BusStopInfoResponse(
                        busStopName: "옛골",
                        busStopId: "22324",
                        direction: "새쟁이마을",
                        longitude: "127.070438",
                        latitude: "37.430946"
                    ),
                    BusStopInfoResponse(
                        busStopName: "옛골",
                        busStopId: "22341",
                        direction: "청계산옛골",
                        longitude: "127.0707733294",
                        latitude: "37.4305370286"
                    )
                ]
            )
        }
    }
}
    
#endif
