//
//  DefaultFavoritesRepository.swift
//  Data
//
//  Created by gnksbm on 1/30/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import CoreDataService
import Domain

import RxSwift

public final class DefaultFavoritesRepository: FavoritesRepository {
    private let coreDataService: CoreDataService
    
    public var favorites = BehaviorSubject<[FavoritesBusStopResponse]>(
        value: []
    )
    private let disposeBag = DisposeBag()
    
    public init(
        coreDataService: CoreDataService
    ) {
        self.coreDataService = coreDataService
        fetchFavorites()
    }
    
    public func addRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) throws {
        do {
            let oldFavorites = try favorites.value()
            let hasBusStopId = try coreDataService.duplicationCheck(
                type: FavoritesBusStopResponse.self,
                uniqueKeyPath: \.busStopId,
                uniqueValue: arsId
            )
            if hasBusStopId {
                guard let busStopToUpdate = oldFavorites
                    .first(
                        where: {
                            $0.busStopId == arsId
                        }
                    )
                else { return }
                let busIdArrToUpdate = busStopToUpdate.busIds + [bus.busId]
                let newFavorites = FavoritesBusStopResponse(
                    busStopId: busStopToUpdate.busStopId,
                    busIds: busIdArrToUpdate
                )
                do {
                    try coreDataService.update(
                        data: newFavorites,
                        uniqueKeyPath: \.busStopId
                    )
                } catch {
                    throw error
                }
            } else {
                do {
                    try coreDataService.save(
                        data: FavoritesBusStopResponse(
                            busStopId: arsId,
                            busIds: [bus.busId]
                        )
                    )
                } catch {
                    throw error
                }
            }
            fetchFavorites()
        } catch {
            throw error
        }
    }
    
    public func removeRoute(
        arsId: String,
        bus: BusArrivalInfoResponse
    ) throws {
        do {
            let oldFavorites = try favorites.value()
            guard let busStopToRemove = oldFavorites
                .first(
                    where: {
                        $0.busStopId == arsId
                    }
                )
            else { return }
            if busStopToRemove.busIds.count > 1 {
                let newBusId = busStopToRemove.busIds.filter { $0 != bus.busId }
                do {
                    try coreDataService.update(
                        data: FavoritesBusStopResponse(
                            busStopId: arsId,
                            busIds: newBusId
                        ),
                        uniqueKeyPath: \.busStopId
                    )
                } catch {
                    throw error
                }
            } else {
                do {
                    try coreDataService.delete(
                        data: FavoritesBusStopResponse(
                            busStopId: arsId,
                            busIds: [bus.busId]
                        ),
                        uniqueKeyPath: \.busStopId
                    )
                } catch {
                    throw error
                }
            }
            fetchFavorites()
        } catch {
            throw error
        }
    }
    
    private func fetchFavorites() {
        do {
            let fetchedFavorites = try coreDataService.fetch(
                type: FavoritesBusStopResponse.self
            )
            favorites.onNext(fetchedFavorites)
        } catch {
            favorites.onError(error)
        }
    }
}
