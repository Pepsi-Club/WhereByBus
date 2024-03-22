//
//  BusStopListDTO.swift
//  Data
//
//  Created by gnksbm on 1/28/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

struct BusStopListDTO: Codable {
    let description: Description
    let data: [BusStopInfo]

    enum CodingKeys: String, CodingKey {
        case description = "DESCRIPTION"
        case data = "DATA"
    }
}

extension BusStopListDTO {
    var toDomain: [BusStopInfoResponse] {
        data.map {
            .init(
                busStopName: $0.stopNm,
                busStopId: $0.stopNo,
                direction: $0.nxtStn,
                longitude: $0.xcode,
                latitude: $0.ycode
            )
        }
    }
    // MARK: - Datum
    struct BusStopInfo: Codable {
        let stopNm, ycode, stopNo, xcode, nxtStn: String
        // stopType
        // "가로변시간", "가로변전일", "가상정류장", "마을버스", "일반차로", "중앙차로"
        let stopType: String
        let nodeID: String
        
        enum CodingKeys: String, CodingKey {
            case stopNm = "stop_nm"
            case ycode
            case stopNo = "stop_no"
            case xcode
            case nxtStn
            case stopType = "stop_type"
            case nodeID = "node_id"
        }
    }
    
    // MARK: - Description
    struct Description: Codable {
        let stopType, ycode, stopNm, nodeID: String
        let stopNo, xcode, nxtStn: String
        
        enum CodingKeys: String, CodingKey {
            case stopType = "STOP_TYPE"
            case ycode = "YCODE"
            case stopNm = "STOP_NM"
            case nodeID = "NODE_ID"
            case stopNo = "STOP_NO"
            case xcode = "XCODE"
            case nxtStn = "NXT_STN"
        }
    }
}
