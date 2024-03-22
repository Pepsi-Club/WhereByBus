import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift

public final class RegularAlarmViewModel: ViewModel {
    private let coordinator: RegularAlarmCoordinator
    @Injected(RegularAlarmUseCase.self) var useCase: RegularAlarmUseCase
    
    private let disposeBag = DisposeBag()
    
    public init(coordinator: RegularAlarmCoordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator.finish()
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(
            regularAlarmList: .init()
        )
        
        input.viewWillAppearEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.fetchAlarm()
                }
            )
            .disposed(by: disposeBag)
        
        input.addBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.coordinator.startAddRegularAlarmFlow()
                }
            )
            .disposed(by: disposeBag)
        
        input.editItemSelected
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, response in
                    viewModel.coordinator.startAddRegularAlarmFlow(
                        with: response
                    )
                }
            )
            .disposed(by: disposeBag)

        input.removeItemSelected
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, response in
                    do {
                        try viewModel.useCase.removeAlarm(response: response)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        useCase.fetchedAlarm
            .bind(to: output.regularAlarmList)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension RegularAlarmViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
        let addBtnTapEvent: Observable<Void>
        let editItemSelected: Observable<RegularAlarmResponse>
        let removeItemSelected: Observable<RegularAlarmResponse>
    }
    
    public struct Output {
        let regularAlarmList: PublishSubject<[RegularAlarmResponse]>
    }
}
