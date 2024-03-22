//
//  BusStopArrivalInfoResponse.swift
//  Domain
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct BusStopArrivalInfoResponse: Codable, Hashable {
    public let busStopId: String
    public let busStopName: String
    public let direction: String
    public var buses: [BusArrivalInfoResponse]
    
    public init(
        busStopId: String,
        busStopName: String,
        direction: String,
        buses: [BusArrivalInfoResponse]
    ) {
        self.busStopId = busStopId
        self.busStopName = busStopName
        self.direction = direction
        self.buses = buses
    }
}

public struct BusArrivalInfoResponse: Codable, Hashable {
    public let busId: String
    public let busName: String
    public let busType: BusType
    public let nextStation: String
    public let firstArrivalState: ArrivalState
    public let firstArrivalRemaining: String
    public let secondArrivalState: ArrivalState
    public let secondArrivalRemaining: String
    public var isFavorites: Bool
    public var isAlarmOn: Bool
    
    public init(
        busId: String,
        busName: String,
        busType: String,
        nextStation: String,
        firstArrivalState: ArrivalState,
        firstArrivalRemaining: String,
        secondArrivalState: ArrivalState,
        secondArrivalRemaining: String,
        isFavorites: Bool,
        isAlarmOn: Bool
    ) {
        self.busId = busId
        self.busName = busName
        self.busType = BusType(rawValue: busType) ?? .common
        self.nextStation = nextStation
        self.firstArrivalState = firstArrivalState
        self.firstArrivalRemaining = firstArrivalRemaining
        self.secondArrivalState = secondArrivalState
        self.secondArrivalRemaining = secondArrivalRemaining
        self.isFavorites = isFavorites
        self.isAlarmOn = isAlarmOn
    }
}

public enum ArrivalState: Hashable, Codable {
    case soon, pending, finished, arrivalTime(time: Int)
    
    public var toString: String {
        switch self {
        case .soon:
            return "곧 도착"
        case .pending:
            return "출발대기"
        case .finished:
            return "운행종료"
        case .arrivalTime(let time):
            return "\(time / 60)분후"
        }
    }
}

public enum BusType: String, Codable {
    case common = "0"
    case airport = "1"
    case village = "2"
    case trunkLine = "3"
    case branchLine = "4"
    case circulation = "5"
    case wideArea = "6"
    case incheon = "7"
    case gyeonggi = "8"
    case abolition = "9"
    
    public var toString: String {
        switch self {
        case .common:
            return "공용"
        case .airport:
            return "공항"
        case .village:
            return "마을"
        case .trunkLine:
            return "간선"
        case .branchLine:
            return "지선"
        case .circulation:
            return "순환"
        case .wideArea:
            return "광역"
        case .incheon:
            return "인천"
        case .gyeonggi:
            return "경기"
        case .abolition:
            return "폐지"
        }
    }
}
