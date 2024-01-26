//
//  StationArrivalInfoRepository.swift
//  Domain
//
//  Created by gnksbm on 1/25/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol StationArrivalInfoRepository {
    func fetchArrivalList(stationId: String) -> Observable<Data>
}