//
//  LocationService.swift
//  Domain
//
//  Created by Muker on 3/12/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation
import CoreLocation

import RxSwift
import RxRelay

public protocol LocationService {
	var authState: BehaviorSubject<CLAuthorizationStatus> { get }
	var currentLocation: BehaviorSubject<CLLocation> { get }
	
    func authorize()
	func requestLocationOnce()
	func startUpdatingLocation()
	func stopUpdatingLocation()
    func getDistance(response: BusStopInfoResponse) -> String
}
