//
//  MockFavoritesRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockFavoritesRepository: FavoritesRepository {
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: []
    )
    
    public init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.favorites.onNext(
                [
                    BusStopArrivalInfoResponse(
                        busStopId: "23290",
                        busStopName: "강남구보건소",
                        direction: "강남구청역",
                        buses: [
                            BusArrivalInfoResponse(
                                busId: "124000038",
                                busName: "342",
                                busType: BusType.trunkLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalState: ArrivalState
                                    .arrivalTime(time: 297),
                                firstArrivalRemaining: "3번째 전",
                                secondArrivalState: ArrivalState
                                    .arrivalTime(time: 913),
                                secondArrivalRemaining: "6번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100075",
                                busName: "472",
                                busType: BusType.trunkLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalState: ArrivalState
                                    .arrivalTime(time: 198),
                                firstArrivalRemaining: "1번째 전",
                                secondArrivalState: ArrivalState
                                    .arrivalTime(time: 566),
                                secondArrivalRemaining: "5번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100226",
                                busName: "3414",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "삼성동서광아파트",
                                firstArrivalState: ArrivalState.soon,
                                firstArrivalRemaining: "",
                                secondArrivalState: ArrivalState
                                    .arrivalTime(time: 1086),
                                secondArrivalRemaining: "9번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100612",
                                busName: "3426",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "삼성동서광아파트",
                                firstArrivalState: ArrivalState.soon,
                                firstArrivalRemaining: "",
                                secondArrivalState: ArrivalState
                                    .arrivalTime(time: 689),
                                secondArrivalRemaining: "6번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            ),
                            BusArrivalInfoResponse(
                                busId: "100100500",
                                busName: "4312",
                                busType: BusType.branchLine.rawValue,
                                nextStation: "강남구청역",
                                firstArrivalState: ArrivalState
                                    .arrivalTime(time: 490),
                                firstArrivalRemaining: "4번째 전",
                                secondArrivalState: ArrivalState
                                    .arrivalTime(time: 916),
                                secondArrivalRemaining: "9번째 전",
                                isFavorites: false,
                                isAlarmOn: false
                            )
                        ]
                    )
                ].map {
                    .init(
                        busStopId: $0.busStopId,
                        busIds: $0.buses.map({ $0.busId })
                    )
                }
            )
        }
    }
    
    public func addRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            var oldFavorites = try favorites.value()
            if oldFavorites.contains(where: { $0.busStopId == arsId }) {
                guard let favoriteToChange = oldFavorites
                    .first(where: { $0.busStopId == arsId })
                else { return }
                let newBusIds = favoriteToChange.busIds + [bus.busId]
                var newFavorites = oldFavorites.filter { $0.busStopId != arsId }
                newFavorites.append(
                    .init(
                        busStopId: arsId,
                        busIds: newBusIds
                    )
                )
                favorites.onNext(newFavorites)
                return
            }
            oldFavorites.append(
                .init(
                    busStopId: arsId,
                    busIds: [bus.busId]
                )
            )
            favorites.onNext(oldFavorites)
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
    public func removeRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) {
        do {
            var oldFavorites = try favorites.value()
            if let index = oldFavorites.firstIndex(where: { $0.busStopId == arsId }) {
                var favoriteToChange = oldFavorites[index]
                favoriteToChange.busIds.removeAll(where: { $0 == bus.busId })
                if favoriteToChange.busIds.isEmpty {
                    oldFavorites.remove(at: index)
                } else {
                    oldFavorites[index] = favoriteToChange
                }
                favorites.onNext(oldFavorites)
            }
        } catch {
            print(error, "즐겨찾기 업데이트 실패")
        }
    }
}
#endif
