//
//  ViewModel.swift
//  PresentationDependency
//
//  Created by gnksbm on 1/20/24.
//  Copyright © 2024 Pepsi-Club. All rights reserved.
//

import Foundation

import RxSwift

public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
