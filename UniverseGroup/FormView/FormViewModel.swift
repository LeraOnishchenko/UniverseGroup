//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 02.07.2024.
//
import RxSwift

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
        OnboardingService.shared.fetchOnboardingDataSingle()
            .subscribe(onSuccess: { [weak self] (response) in
                self?.questions = response
                self?.currentIndex = 0
                self?.showCurrentQuestion()
            },
                       onFailure: { [weak self] (err) in
                self?.questions = []
                self?.currentIndex = 0
                self?.showCurrentQuestion()
            })
            .disposed(by: disposeBag)
    }

    private func showCurrentQuestion() {
        guard currentIndex < questions.count else { return }
        let currentQuestion = questions[currentIndex]
        questionSubject.onNext(currentQuestion)
    }

    private func showNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            showCurrentQuestion()
        } else {
            isCompletedSubject.onNext(true)
        }
    }
    
}
extension FormViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if questions.count == 0{
            return 0
        }
        return questions[currentIndex].answers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        cellSelected.onNext(questions[currentIndex].answers[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        let answers = questions[currentIndex].answers
        cell.configare(text: answers[indexPath.section])
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .cellSelect
        cell.selectedBackgroundView = selectedBackgroundView
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    
}
