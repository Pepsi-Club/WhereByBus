//
//  NearBusStopResponse.swift
//  Domain
//
//  Created by Muker on 3/5/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

public struct NearBusStopResponse {
	public let busStopId: String
	public let busStopName: String
	public let direction: String?
	public let latitude: String // 위도
	public let lonitude: String // 경도
	public let distance: Int // 내위치에서 떨어진 거리
	
	public init(
		busStopId: String,
		busStopName: String,
		direction: String?,
		latitude: String,
		lonitude: String,
		distance: Int
	) {
		self.busStopId = busStopId
		self.busStopName = busStopName
		self.direction = direction
		self.latitude = latitude
		self.lonitude = lonitude
		self.distance = distance
	}
}

extension NearBusStopResponse {
	static public var mockBusStop = NearBusStopResponse(
		busStopId: "123",
		busStopName: "예비정류장",
		direction: "방면",
		latitude: "456456",
		lonitude: "123123",
		distance: 100
	)
}
