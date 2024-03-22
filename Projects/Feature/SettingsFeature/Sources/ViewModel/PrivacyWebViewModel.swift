//
//  PrivacyWebViewModel.swift
//  SettingsFeature
//
//  Created by Jisoo HAM on 2/29/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import Domain
import FeatureDependency

import RxSwift

public final class PrivacyWebViewModel: ViewModel {
    private let coordinator: SettingsCoordinator
    public var urlString: String
    private let disposeBag = DisposeBag()
    
    public init(
        coordinator: SettingsCoordinator,
        urlString: String
    ) {
        self.coordinator = coordinator
        self.urlString = urlString
    }
    
    public func transform(input: Input) -> Output {
        let output = Output(privacyString: .init())
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let combinedUrlString = "https://" + self.urlString
                output.privacyString.onNext(combinedUrlString)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}
extension PrivacyWebViewModel {
    public struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    public struct Output {
        var privacyString: PublishSubject<String>
    }
}
