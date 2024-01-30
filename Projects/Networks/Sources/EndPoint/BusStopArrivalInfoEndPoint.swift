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
    let busStopId: String
    
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
        "/api/rest/arrive/getLowArrInfoByStId"
    }
    
    public var query: [String: String] {
        [
            "ServiceKey": .serverKey,
            "stId": busStopId
        ]
    }
    
    public var header: [String: String] {
        [:]
    }
    
    public var body: [String: String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public init(busStopId: String) {
        self.busStopId = busStopId
    }
}