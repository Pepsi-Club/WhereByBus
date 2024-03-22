import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

public final class FavoritesViewModel: ViewModel {
    private let coordinator: HomeCoordinator
    @Injected(FavoritesUseCase.self) var useCase: FavoritesUseCase
    
    private let disposeBag = DisposeBag()
    private var timer: BCTimer
    
    public init(
        coordinator: HomeCoordinator,
        timer: BCTimer
    ) {
        self.coordinator = coordinator
        self.timer = timer
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            busStopArrivalInfoResponse: .init(),
            favoritesState: .init(),
            distanceFromTimerStart: .init(value: 0)
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.fetchFavoritesArrivals()
                }
            )
            .disposed(by: disposeBag)
        
        input.searchBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startSearchFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.refreshBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    output.favoritesState.onNext(.fetching)
                    viewModel.useCase.fetchFavoritesArrivals()
                }
            )
            .disposed(by: disposeBag)
        
        input.busStopTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, selectedId in
                    do {
                        let responses = try viewModel.useCase
                            .busStopArrivalInfoResponse.value()
                        guard let selectedBusStop = responses.first(
                            where: { response in
                                response.busStopId == selectedId
                            }
                        )
                        else { return }
                        viewModel.coordinator.startBusStopFlow(
                            stationId: selectedBusStop.busStopId
                        )
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        timer.distanceFromStart
            .bind(to: output.distanceFromTimerStart)
            .disposed(by: disposeBag)
        
        useCase.busStopArrivalInfoResponse
            .subscribe(
                onNext: { responses in
                    output.busStopArrivalInfoResponse.onNext(responses)
                    if responses.isEmpty {
                        output.favoritesState.onNext(.emptyFavorites)
                    } else {
                        output.favoritesState.onNext(.fetchComplete)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        output.favoritesState
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, state in
                    switch state {
                    case .emptyFavorites:
                        break
                    case .fetching:
                        viewModel.timer.stop()
                    case .fetchComplete:
                        viewModel.timer.start()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        return output        
    }
}

extension FavoritesViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let refreshBtnTapEvent: Observable<Void>
        let alarmBtnTapEvent: Observable<IndexPath>
        let busStopTapEvent: Observable<String>
    }
    
    public struct Output {
        var busStopArrivalInfoResponse
        : PublishSubject<[BusStopArrivalInfoResponse]>
        var favoritesState: PublishSubject<FavoritesState>
        var distanceFromTimerStart: BehaviorRelay<Int>
    }
    
    enum FavoritesState {
        case emptyFavorites, fetching, fetchComplete
    }
}
