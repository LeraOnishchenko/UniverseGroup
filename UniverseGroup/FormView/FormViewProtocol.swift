//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 04.07.2024.
//

import RxSwift

protocol FormViewModelInput {
    var nextButtonTapped: AnyObserver<Void> { get }
    var cellSelected: AnyObserver<String> { get }
}

protocol FormViewModelOutput {
    var question: Observable<OnboardingStep> { get }
    var isCompleted: Observable<Bool> { get }
    var selectedAnswer: Observable<String?> {get}
}
