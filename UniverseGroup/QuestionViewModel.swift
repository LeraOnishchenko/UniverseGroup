import RxSwift

class QuestionViewModel: QuestionViewModelType, QuestionViewModelInput, QuestionViewModelOutput {
    
    var input: QuestionViewModelInput { return self }
    var output: QuestionViewModelOutput { return self }
    
    let fetchNextQuestion = PublishSubject<Void>()
    
    let question: Observable<String>
    let answers: Observable<[String]>
    
    private let questionSubject = BehaviorSubject<String>(value: "")
    private let answersSubject = BehaviorSubject<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    private var questions: [OnboardingStep] = []
    private var currentIndex = 0
    
    
    private let onboardingService = OnboardingService()
    
    init() {
        question = questionSubject.asObservable()
        answers = answersSubject.asObservable()
        
        fetchNextQuestion
            .subscribe(onNext: { [unowned self] in
                self.showNextQuestion()
            })
            .disposed(by: disposeBag)
        
        fetchQuestionsFromEndpoint()
    }
    
    private func fetchQuestionsFromEndpoint() {
        onboardingService.fetchOnboardingData { [weak self] steps in
            self?.questions = steps ?? []
            self?.currentIndex = 0
            self?.showCurrentQuestion()
        }
        
    }
    
    private func showCurrentQuestion() {
        guard currentIndex < questions.count else { return }
        let currentQuestion = questions[currentIndex]
        questionSubject.onNext(currentQuestion.question)
        answersSubject.onNext(currentQuestion.answers)
    }
    
    private func showNextQuestion() {
        currentIndex += 1
        if currentIndex < questions.count {
            showCurrentQuestion()
        } else {
            // Handle the end of the questions if needed
        }
    }
}
