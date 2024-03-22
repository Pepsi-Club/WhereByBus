//
//  MockBusStopArrivalInfoRepository.swift
//  FeatureDependency
//
//  Created by gnksbm on 3/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

import RxSwift

#if DEBUG
public final class MockBusStopArrivalInfoRepository
: BusStopArrivalInfoRepository {
    public init() { }
    
    public func fetchArrivalList(
        busStopId: String
    ) -> Observable<BusStopArrivalInfoResponse> {
        .create { observer in
            observer.onNext(
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
                                .arrivalTime(time: 62),
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
                        ),
                        BusArrivalInfoResponse(
                            busId: "100100226",
                            busName: "3414",
                            busType: BusType.airport.rawValue,
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
                            busType: BusType.airport.rawValue,
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
                            busType: BusType.airport.rawValue,
                            nextStation: "강남구청역",
                            firstArrivalState: ArrivalState
                                .arrivalTime(time: 490),
                            firstArrivalRemaining: "4번째 전",
                            secondArrivalState: ArrivalState
                                .arrivalTime(time: 916),
                            secondArrivalRemaining: "9번째 전",
                            isFavorites: false,
                            isAlarmOn: false
                        ),
                        BusArrivalInfoResponse(
                            busId: "1001005001",
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
                        ),
                        BusArrivalInfoResponse(
                            busId: "1001005002",
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
                        ),
                        BusArrivalInfoResponse(
                            busId: "1001005003",
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
                        ),
                        BusArrivalInfoResponse(
                            busId: "1001005004",
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
            )
            return Disposables.create()
        }
    }
}
#endif
