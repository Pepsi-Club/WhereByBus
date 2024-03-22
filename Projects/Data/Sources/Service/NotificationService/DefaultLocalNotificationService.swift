//
//  DefaultLocalNotificationService.swift
//  Domain
//
//  Created by gnksbm on 2/27/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import UserNotifications

import Core
import Domain
import NetworkService

import RxSwift

public final class DefaultLocalNotificationService: LocalNotificationService {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    public let authState = BehaviorSubject<UNAuthorizationStatus>(
        value: .denied
    )
    private let disposeBag = DisposeBag()
    
    public init() { }
    
    public func authorize() {
        notificationCenter.getNotificationSettings { [weak self] setting in
            self?.authState.onNext(setting.authorizationStatus)
        }
        authState
            .withUnretained(self)
            .subscribe(
                onNext: { notiService, state in
                    guard state != .authorized else { return }
                    notiService.notificationCenter.requestAuthorization(
                        options: [.alert, .sound, .badge]
                    ) { isAuthorized, error in
                        if let error {
                            notiService.authState.onError(error)
                        }
                        if isAuthorized {
                            notiService.authState.onNext(.authorized)
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func fetchRegularAlarm() -> Observable<[RegularAlarmResponse]> {
        return .create { [weak self] observer in
            self?.notificationCenter.getPendingNotificationRequests { result in
                let responses: [RegularAlarmResponse] = result.compactMap {
                    let userInfo = $0.content.userInfo
                    guard let busStopId = userInfo["busStopId"] as? String,
                          let busStopName = userInfo["busStopName"] as? String,
                          let busId = userInfo["busId"] as? String,
                          let busName = userInfo["busName"] as? String,
                          let time = userInfo["time"] as? Date,
                          let weekDay = userInfo["weekday"] as? [Int]
                    else { return nil }
                    return RegularAlarmResponse(
                        requestId: $0.identifier,
                        busStopId: busStopId,
                        busStopName: busStopName,
                        busId: busId,
                        busName: busName,
                        time: time,
                        weekDay: weekDay
                    )
                }
                observer.onNext(Array(Set(responses)))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    public func registNewRegularAlarm(response: RegularAlarmResponse) throws {
        let notificationRequests = response.weekday.map { weekday in
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.weekday = weekday
            let dateStr = response.time
                .toString(dateFormat: "HH:mm")
                .split(separator: ":")
                .compactMap { Int($0) }
            dateComponents.hour = dateStr.first
            dateComponents.minute = dateStr.last
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )
            let content = UNMutableNotificationContent()
            content.sound = .default
            let remaining = "\(response.busStopName)에 \(response.busName)번 "
            let body = "\(remaining)버스가 곧 도착합니다."
            content.title = "버스어디"
            content.body = body
            content.userInfo["busStopId"] = response.busStopId
            content.userInfo["busStopName"] = response.busStopName
            content.userInfo["busId"] = response.busId
            content.userInfo["busName"] = response.busName
            content.userInfo["time"] = response.time
            content.userInfo["weekday"] = response.weekday
            let request = UNNotificationRequest(
                identifier: response.requestId,
                content: content,
                trigger: trigger
            )
            return request
        }
        notificationRequests.forEach {
            notificationCenter.add($0)
        }
    }
    
    public func editRegularAlarm(response: RegularAlarmResponse) throws {
        do {
            try removeRegularAlarm(response: response)
            do {
                try registNewRegularAlarm(response: response)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    public func removeRegularAlarm(response: RegularAlarmResponse) throws {
        let identifier = [response.requestId]
        notificationCenter.removeDeliveredNotifications(
            withIdentifiers: identifier
        )
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: identifier
        )
    }
}
