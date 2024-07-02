//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 02.07.2024.
//
import RxSwift

protocol QuestionViewModelInput {
    var fetchNextQuestion: PublishSubject<Void> { get }
}

protocol QuestionViewModelOutput {
    var question: Observable<String> { get }
    var answers: Observable<[String]> { get }
}

protocol QuestionViewModelType {
    var input: QuestionViewModelInput { get }
    var output: QuestionViewModelOutput { get }
}
