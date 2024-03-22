//
//  BusStopArrivalInfoDTO.swift
//  Data
//
//  Created by gnksbm on 3/3/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain

public struct BusStopArrivalInfoDTO: Codable {
    let msgHeader: MsgHeader
    let msgBody: MsgBody
}

public extension BusStopArrivalInfoDTO {
    var toDomain: BusStopArrivalInfoResponse {
        guard msgHeader.headerCD == "0"
        else {
            return .init(
                busStopId: msgHeader.headerCodeMessage,
                busStopName: "",
                direction: "",
                buses: getBuses
            )
        }
        return .init(
            busStopId: getBusStopId ?? "정류장 ID 없음",
            busStopName: getBusStopName ?? "정류장 이름 없음",
            direction: getDirection ?? "정류장 방면 없음",
            buses: getBuses
        )
    }
    
    private var getBusStopId: String? {
        msgBody.itemList?.first?.arsId
    }
    
    private var getBusStopName: String? {
        msgBody.itemList?.first?.stNm
    }
    
    private var getBusStopNum: String? {
        msgBody.itemList?.first?.arsId
    }
    
    private var getDirection: String? {
        let nextStations = msgBody.itemList?.compactMap { $0.nxtStn }
        var dic = [String: Int]()
        nextStations?.forEach { nextStation in
            dic[nextStation, default: 0] += 1
        }
        let direction = dic.mapValues { $0 }
            .sorted { $0.value > $1.value }
            .first?
            .key
        return direction
    }
    
    private var getBuses: [BusArrivalInfoResponse] {
        guard let itemList = msgBody.itemList else { return [] }
        return itemList
            .map { item in
                let firstMsgArr = (item.arrmsg1 ?? "운행종료")
                    .components(separatedBy: "[")
                let secondMsgArr = (item.arrmsg2 ?? "운행종료")
                    .components(separatedBy: "[")
                var firstArrivalRemaining = ""
                var secondArrivalRemaining = ""
                if firstMsgArr.count > 1 {
                    firstArrivalRemaining = firstMsgArr[1]
                    firstArrivalRemaining = 
                    firstArrivalRemaining.components(separatedBy: "]")[0]
                }
                if secondMsgArr.count > 1 {
                    secondArrivalRemaining = secondMsgArr[1]
                    secondArrivalRemaining =
                    secondArrivalRemaining.components(separatedBy: "]")[0]
                }
                let firstArrivalState: ArrivalState
                let secondArrivalState: ArrivalState
                switch firstMsgArr.first {
                case .some(let msg):
                    switch msg {
                    case "곧 도착":
                        firstArrivalState = .soon
                    case "출발대기":
                        firstArrivalState = .pending
                    case "운행종료":
                        firstArrivalState = .finished
                    default:
                        firstArrivalState = .arrivalTime(
                            time: Int(item.traTime1 ?? "0") ?? 0
                        )
                    }
                case .none:
                    firstArrivalState = .arrivalTime(
                        time: Int(item.traTime1 ?? "0") ?? 0
                    )
                }
                switch secondMsgArr.first {
                case .some(let msg):
                    switch msg {
                    case "곧 도착":
                        secondArrivalState = .soon
                    case "출발대기":
                        secondArrivalState = .pending
                    case "운행종료":
                        secondArrivalState = .finished
                    default:
                        secondArrivalState = .arrivalTime(
                            time: Int(item.traTime2 ?? "0") ?? 0
                        )
                    }
                case .none:
                    secondArrivalState = .arrivalTime(
                        time: Int(item.traTime2 ?? "0") ?? 0
                    )
                }
                return .init(
                    busId: item.busRouteId ?? "ID 정보 없음",
                    busName: item.rtNm ?? "이름 정보 없음",
                    busType: item.routeType ?? "타입 정보 없음",
                    nextStation: item.nxtStn ?? "정거장 정보 없음",
                    firstArrivalState: firstArrivalState,
                    firstArrivalRemaining: firstArrivalRemaining,
                    secondArrivalState: secondArrivalState,
                    secondArrivalRemaining: secondArrivalRemaining,
                    isFavorites: false,
                    isAlarmOn: false
                )
            }
    }
}

extension BusStopArrivalInfoDTO {
    struct MsgHeader: Codable {
        let headerMsg, headerCD: String
        let itemCount: Int
        
        enum CodingKeys: String, CodingKey {
            case headerMsg
            case headerCD = "headerCd"
            case itemCount
        }
        
        var headerCodeMessage: String {
            switch headerCD {
            case "0":
                return "정상적으로 처리되었습니다"
            case "1":
                return "시스템 오류가 발생하였습니다"
            case "2":
                return "잘못된 쿼리 요청입니다. 쿼리 변수가 정확한지 확인하세요."
            case "3":
                return "정류소를 찾을 수 없습니다"
            case "4":
                return "노선을 찾을 수 없습니다."
            case "5":
                return "잘못된 위치로 요청을 하였습니다. 위/경도 좌표가 정확한지 확인하세요"
            case "6":
                return "실시간 정보를 읽을 수 없습니다. 잠시 후 다시 시도하세요"
            case "7":
                return "경로 검색 결과가 존재하지 않습니다."
            case "8":
                return "운행 종료되었습니다."
            default:
                return "잘못된 헤더코드 입니다."
            }
        }
    }
    // MARK: - MsgBody
    struct MsgBody: Codable {
        let itemList: [Item]?
    }
    
    struct Item: Codable {
        let busRouteId: String? // 노선ID
        let rtNm: String? // 노선명
        let nxtStn: String? // 다음 정류장 이름
        let routeType: String? // 노선유형
        // (1:공항, 2:마을, 3:간선, 4:지선, 5:순환, 6:광역, 7:인천, 8:경기, 9:폐지, 0:공용)
        let arsId: String // 정류소 번호
        let stId: String? // 정류소 고유 ID
        let stNm: String? // 정류소명
        let busRouteAbrv: String? //
        let sectNm: String? // 구간명
        let gpsX: String // 정류소 X좌표
        let gpsY: String // 정류소 Y좌표
        let posX: String? // 정류소 좌표X
        let posY: String? // 정류소 좌표Y
        let stationTp: String // 정류소 타입
        // (0:공용, 1:일반형 시내/농어촌버스, 2:좌석형 시내/농어촌버스,
        // 3:직행좌석형 시내/농어촌버스, 4:일반형 시외버스, 5:좌석형 시외버스, 6:고속형 시외버스,
        // 7:마을버스)
        let firstTm: String? // 첫차시간
        let lastTm: String? // 막차시간
        let term: String? // 배차간격 (분)
        let nextBus: String? // 막차운행여부
        let adirection: String? //
        let deTourAt: String? // 우회여부
        // MARK: 첫번째 도착 예정 버스
        let arrmsg1: String? // 첫번째도착예정버스의 도착정보메시지
        let vehId1: String? // 첫번째도착예정버스ID
        let sectOrd1: String? // 첫번째도착예정버스의 현재구간 순번
        let stationNm1: String? //  첫번째도착예정버스의 최종 정류소명
        let traTime1: String? // 첫번째도착예정버스의 여행시간
        let traSpd1: String? // 첫번째도착예정버스의 여행속도
        let isArrive1: String? // 첫번째도착예정버스의 최종 정류소 도착출발여부(0
        let repTm1: String? // 첫번째도착예정버스의 최종 보고 시간
        let isLast1: String? // 첫번째도착예정버스의 막차여부
        let busType1: String? // 첫번째도착예정버스의 차량유형 (0:일반버스, 1:저상)
        let arrmsgSec1: String? // 첫번째도착예정버스의 도착정보메시지
        let rerdieDiv1: String? //  첫번째도착예정버스의 재차구분
        let rerideNum1: String? // 첫번째도착예정버스의 재차인원
        let isFullFlag1: String? // 첫번째도착예정버스의 만차여부
        let congestion1: String? //
        //        let plainNo1: String // null
        //        let staOrd1: String // 값 없음, 첫번째도착예정버스의 현재구간 순번
        // MARK: 두번째 도착 예정 버스
        let arrmsg2: String?    // 두번째도착예정버스의 도착정보메시지
        let vehId2: String? // 두번째도착예정버스ID
        let sectOrd2: String?    // 두번째도착예정버스의 현재구간 순번
        let stationNm2: String? // 두번째도착예정버스의 최종 정류소명
        let traTime2: String?    // 두번째도착예정버스의 여행시간
        let traSpd2: String?    // 두번째도착예정버스의 여행속도
        let isArrive2: String?    //  두번째도착예정버스의 최종 정류소 도착출발여부(0
        //        let repTm2: String    // ⭐️null⭐️, 두번째도착예정버스의 최종 보고 시간
        let isLast2: String?    // 두번째도착예정버스의 막차여부
        let busType2: String?    // 두번째도착예정버스의 차량유형 (0:일반버스, 1:저상)
        let arrmsgSec2: String?    // 두번째도착예정버스의 도착정보메시지
        let rerdieDiv2: String?    // 두번째도착예정버스의 재차구분
        let rerideNum2: String?    // 두번째도착예정버스의 재차인원
        let isFullFlag2: String?    //  두번째도착예정버스의 만차여부
        let congestion2: String?    //
        //        let plainNo2: String // null
    }
}
