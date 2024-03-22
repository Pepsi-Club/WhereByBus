//
//  BusStopArrivalInfoEndPoint.swift
//  Networks
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core

public struct BusStopArrivalInfoEndPoint: EndPoint {
    private let arsId: String
    
    public var scheme: Scheme {
        .http
    }
    
    public var host: String {
        "ws.bus.go.kr"
    }
    
    public var port: String {
        ""
    }
    
    public var path: String {
        "/api/rest/stationinfo/getStationByUid"
    }
    
    public var query: [String: String] {
        [
            "resultType": "json",
            "ServiceKey": .serverKey,
            "arsId": arsId
        ]
    }
    
    public var header: [String: String] {
        [:]
    }
    
    public var body: [String: Any] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(arsId: String) {
        self.arsId = arsId
    }
}
