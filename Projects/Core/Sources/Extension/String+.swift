//
//  String+.swift
//  Core
//
//  Created by gnksbm on 2023/12/27.
//  Copyright © 2023 Pepsi-Club. All rights reserved.
//

import UIKit
import CoreLocation

public extension String {
    func toDate(dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = .current
        guard let date = dateFormatter.date(from: self)
        else {
            fatalError("Invalid String to dateFormat")
        }
        return date
    }
    
    static var serverKey: Self {
        guard let any = Bundle.main.object(
            forInfoDictionaryKey: "DATA_GO_KR_API_KEY"
        ),
              let serverKey = any as? String
        else { fatalError("Can't Not Find Server Key") }
        return serverKey
    }
    
    static var fcmKey: Self {
        guard let any = Bundle.main.object(forInfoDictionaryKey: "FCM_KEY"),
              let serverKey = (any as? String)?.removingPercentEncoding
        else { fatalError("Can't Not Find Server Key") }
        return serverKey
    }
	
	static func calculationDistance(
		startPointLatitude: Double,
		startPointLongitude: Double,
		endPointLatitude: Double,
		endPointLongitude: Double
	) -> Int {
		
		let start = CLLocation(
			latitude: startPointLatitude,
			longitude: startPointLongitude
		)
		
		let end = CLLocation(
			latitude: endPointLatitude,
			longitude: endPointLongitude
		)
		
		return Int(start.distance(from: end))
	}
}
