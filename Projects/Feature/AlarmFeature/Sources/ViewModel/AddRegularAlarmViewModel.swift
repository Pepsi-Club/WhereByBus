//
//  AddRegularAlarmViewModel.swift
//  AlarmFeature
//
//  Created by gnksbm on 2/1/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Core
import Domain
import FeatureDependency

import RxSwift
import RxRelay

final class AddRegularAlarmViewModel: ViewModel {
    private let alarmToEdit: RegularAlarmResponse?
    private let coordinator: AddRegularAlarmCoordinator
    @Injected(RegularAlarmEditingService.self) 
    private var regularAlarmEditingService: RegularAlarmEditingService
    @Injected(AddRegularAlarmUseCase.self) 
    private var useCase: AddRegularAlarmUseCase
    
    private let disposeBag = DisposeBag()
    
    init(
        alarmToEdit: RegularAlarmResponse? = nil,
        coordinator: AddRegularAlarmCoordinator
    ) {
        self.alarmToEdit = alarmToEdit
        self.coordinator = coordinator
    }
    
    deinit {
        regularAlarmEditingService.resetManagedObject()
        coordinator.finish()
    }
    
    func transform(input: Input) -> Output {
        let output = Output(
            title: .init(value: "추가하기"),
            regularAlarm: regularAlarmEditingService.managedAlarm
        )
        if let alarmToEdit {
            output.title.accept("수정하기")
            regularAlarmEditingService.update(response: alarmToEdit)
        }
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    viewModel.useCase.checkNotificationAuth()
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
        
        input.dateSelectEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, time in
                    viewModel.regularAlarmEditingService.update(time: time)
                }
            )
            .disposed(by: disposeBag)
        
        input.weekDayBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, rawValue in
                    let dataToUpdated = viewModel
                        .regularAlarmEditingService.managedAlarm.value
                    let newWeekday: [Int]
                    if dataToUpdated.weekday.contains(rawValue) {
                        newWeekday = dataToUpdated.weekday.filter {
                            $0 != rawValue
                        }
                    } else {
                        newWeekday = dataToUpdated.weekday + [rawValue]
                    }
                    viewModel.regularAlarmEditingService.update(
                        weekday: newWeekday
                    )
                }
            )
            .disposed(by: disposeBag)
        
        input.completeBtnTapEvent
            .withUnretained(self)
            .subscribe(
                onNext: { viewModel, _ in
                    switch output.title.value {
                    case "추가하기":
                        viewModel.useCase.addNewAlarm(
                            response: output.regularAlarm.value
                        )
                    case "수정하기":
                        viewModel.useCase.editAlarm(
                            response: output.regularAlarm.value
                        )
                    default:
                        print("\(String(describing: self)): 잘못된 타이틀")
                    }
                    viewModel.coordinator.finishFlow()
                    viewModel.regularAlarmEditingService.resetManagedObject()
                }
            )
            .disposed(by: disposeBag)
        
        return output
    }
}

extension AddRegularAlarmViewModel {
    struct Input { 
        let viewWillAppear: Observable<Void>
        let searchBtnTapEvent: Observable<Void>
        let dateSelectEvent: Observable<Date>
        let weekDayBtnTapEvent: Observable<Int>
        let completeBtnTapEvent: Observable<Void>
    }
    
    struct Output { 
        let title: BehaviorRelay<String>
        let regularAlarm: BehaviorRelay<RegularAlarmResponse>
    }
}
