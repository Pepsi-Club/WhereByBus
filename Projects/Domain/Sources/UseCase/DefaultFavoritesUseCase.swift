//
//  DefaultFavoritesUseCase.swift
//  Domain
//
//  Created by gnksbm on 1/26/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

public final class DefaultFavoritesUseCase: FavoritesUseCase {
    private let busStopArrivalInfoRepository: BusStopArrivalInfoRepository
    private let favoritesRepository: FavoritesRepository
    
    public let busStopArrivalInfoResponse 
    = BehaviorSubject<[BusStopArrivalInfoResponse]>(value: [])
    private let disposeBag = DisposeBag()
    
    public init(
        busStopArrivalInfoRepository: BusStopArrivalInfoRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.busStopArrivalInfoRepository = busStopArrivalInfoRepository
        self.favoritesRepository = favoritesRepository
    }
    
    public func fetchFavoritesArrivals() {
        do {
            let favoritesBusStops = try favoritesRepository.favorites.value()
            Observable.combineLatest(
                favoritesBusStops
                    .map { response in
                        busStopArrivalInfoRepository.fetchArrivalList(
                            busStopId: response.busStopId
                        )
                    }
            )
            .withUnretained(self)
            .subscribe(
                onNext: { useCase, responses in
                    let filteredResponses = useCase.filterFavorites(
                        fetchedResponses: responses,
                        favoritesBusStops: favoritesBusStops
                    )
                    useCase.busStopArrivalInfoResponse.onNext(filteredResponses)
                }
            )
            .disposed(by: disposeBag)
        } catch {
            busStopArrivalInfoResponse.onError(error)
        }
    }
    
    private func filterFavorites(
        fetchedResponses: [BusStopArrivalInfoResponse],
        favoritesBusStops: [FavoritesBusStopResponse]
    ) -> [BusStopArrivalInfoResponse] {
        let filteredBusStop = fetchedResponses.filter { fetchedResponse in
            favoritesBusStops.contains {
                $0.busStopId == fetchedResponse.busStopId
            }
        }
        let result: [BusStopArrivalInfoResponse] = filteredBusStop
            .compactMap { filteredResponse in
                guard let currentFavorites = favoritesBusStops.first(
                    where: { $0.busStopId == filteredResponse.busStopId }
                )
                else { return nil }
                let filteredBus = filteredResponse.buses
                    .filter { fetchedBusInfo in
                    currentFavorites.busIds.contains { favoriteBusIds in
                        favoriteBusIds == fetchedBusInfo.busId
                    }
                }
                return .init(
                    busStopId: filteredResponse.busStopId,
                    busStopName: filteredResponse.busStopName,
                    direction: filteredResponse.direction,
                    buses: filteredBus
                )
            }
        return result
    }
}
