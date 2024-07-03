//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 02.07.2024.
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

extension FormViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count == 0{
            return 0
        }
        return questions[currentIndex].answers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.textColor = .white
        }
        cellSelected.onNext(questions[currentIndex].answers[row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.textColor = .black
            }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        let answers = questions[currentIndex].answers
        
        cell.textLabel?.text = answers[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.font(.SFPRODISPLAYREGULAR, ofSize: 16)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(red: 71/255, green: 190/255, blue: 154/255, alpha: 1)
        cell.selectedBackgroundView = selectedBackgroundView
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    
}

class FormViewModel: NSObject, FormViewModelInput, FormViewModelOutput {
    var nextButtonTapped: AnyObserver<Void>
    var cellSelected: AnyObserver<String>
    
    var question: Observable<OnboardingStep>
    var isCompleted: Observable<Bool>
    var selectedAnswer: Observable<String?>
    
    private let disposeBag = DisposeBag()
    
    private let nextButtonTappedSubject = PublishSubject<Void>()
    private let cellSelectedSubject = PublishSubject<String>()
    private let isCompletedSubject = PublishSubject<Bool>()
    
    private let questionSubject = BehaviorSubject<OnboardingStep>(value: OnboardingStep(id: 0, answers: [],question: ""))
    private let selectedAnswerSubject = BehaviorSubject<String?>(value: nil)
    
    private var questions: [OnboardingStep] = [
    ]
    private var currentIndex = 0
    
    override init() {
        isCompleted = isCompletedSubject.asObservable()
        question = questionSubject.asObservable()
        selectedAnswer = selectedAnswerSubject.asObservable()
        
        cellSelected = cellSelectedSubject.asObserver()
        nextButtonTapped = nextButtonTappedSubject.asObserver()
        
        
        super.init()
        
        nextButtonTappedSubject
            .subscribe(onNext: { [weak self] in
                self?.showNextQuestion()
            })
            .disposed(by: disposeBag)
        
        cellSelectedSubject
            .subscribe(onNext: { [weak self] answ in
                self?.selectedAnswerSubject.onNext(answ)
            })
            .disposed(by: disposeBag)
        
        fetchQuestionsFromEndpoint()
    }
    
    private func fetchQuestionsFromEndpoint() {
        OnboardingService.shared.fetchOnboardingData { [weak self] steps in
            self?.questions = steps ?? []
            self?.currentIndex = 0
            self?.showCurrentQuestion()
        }
    }

    private func showCurrentQuestion() {
        guard currentIndex < questions.count else { return }
        let currentQuestion = questions[currentIndex]
        questionSubject.onNext(currentQuestion)
    }

    private func showNextQuestion() {
        currentIndex += 1
        if currentIndex < questions.count {
            showCurrentQuestion()
        } else {
            isCompletedSubject.onNext(true)
        }
    }
    
}
