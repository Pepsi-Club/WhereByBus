//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by gnksbm on 3/2/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import UserNotifications

import Data
import Domain
import NetworkService

import RxSwift

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private let repository = DefaultBusStopArrivalInfoRepository(
        networkService: DefaultNetworkService()
    )
    private let disposeBag = DisposeBag()
    
    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler
        : @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = (
            request.content.mutableCopy() as? UNMutableNotificationContent
        )
        guard let bestAttemptContent,
              let aps = bestAttemptContent.userInfo["aps"] as? [String: Any],
              let busStopId = aps["busStopId"] as? String,
              let busId = aps["busId"] as? String
        else { return }
        repository.fetchArrivalList(busStopId: busStopId)
            .subscribe(
                onNext: { response in
                    guard let bus = response.buses.first(
                        where: { busResponse in
                            busResponse.busId == busId
                        }
                    )
                    else { return }
                    let busStopName = response.busStopName
                    let firstArrivalTime = bus.firstArrivalState.toString
                    let firstArrivalRemaining = bus.firstArrivalRemaining
                    let secondArrivalTime = bus.secondArrivalState.toString
                    let routeMessage: String
                    let remainingMessage: String
                    let firstLine: String
                    let secondLine: String
                    switch bus.firstArrivalState.toString {
                    case "곧 도착":
                        routeMessage = "\(bus.busName)번 버스가 \(busStopName)에"
                        remainingMessage = "곧 도착해요."
                        secondLine = "다음 버스는 \(secondArrivalTime) 후에 도착해요."
                    case "운행종료":
                        routeMessage = "\(bus.busName)번 버스는"
                        remainingMessage = "운행종료 되었어요."
                        secondLine = "다음 버스는 \(secondArrivalTime) 후에 도착해요."
                    case "출발대기":
                        routeMessage = "\(bus.busName)번 버스는"
                        remainingMessage = "출발 대기 중 이에요."
                        secondLine = "다음 버스는 \(secondArrivalTime) 후에 도착해요."
                    default:
                        routeMessage = "\(bus.busName)번 버스가 \(busStopName)에"
                        remainingMessage = "\(firstArrivalTime) 후에 도착해요."
                        secondLine = "\(firstArrivalRemaining) 정류장을 지났어요."
                    }
                    firstLine = "\(routeMessage) \(remainingMessage)"
                    let body = [firstLine, secondLine].joined(separator: " ")
                    // TODO: 앱 이름 변경되면 수정해야함
                    bestAttemptContent.title = "버스어디"
                    bestAttemptContent.subtitle = ""
                    bestAttemptContent.body = body
                    contentHandler(bestAttemptContent)
                }
            )
            .disposed(by: disposeBag)
    }
    
    override func serviceExtensionTimeWillExpire() {
    }
}
