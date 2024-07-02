import UIKit
import RxSwift
import SnapKit

class QuestionViewController: UIViewController {
    
    private let viewModel: QuestionViewModelType
    private let disposeBag = DisposeBag()
    
    private let mainText = UILabel()
    private let questionLabel = UILabel()
    private let answersStackView = UIStackView()
    private let continueButton = UIButton()
    
    init(viewModel: QuestionViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        mainText.textAlignment = .left
        mainText.numberOfLines = 0
        mainText.text = "Let’s setup App for you"
        view.addSubview(mainText)
        
        questionLabel.textAlignment = .left
        questionLabel.numberOfLines = 0
        view.addSubview(questionLabel)
        
        answersStackView.axis = .vertical
        answersStackView.spacing = 10
        view.addSubview(answersStackView)
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = .blue
        continueButton.layer.cornerRadius = 5
        view.addSubview(continueButton)
        
        mainText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainText.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        answersStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        viewModel.output.question
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] question in
                self?.questionLabel.text = question
            })
            .disposed(by: disposeBag)
        
        viewModel.output.answers
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] answers in
                self?.answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                answers.forEach { answer in
                    let answerLabel = UILabel()
                    answerLabel.text = answer
                    answerLabel.textAlignment = .center
                    answerLabel.backgroundColor = .lightGray
                    answerLabel.layer.cornerRadius = 5
                    answerLabel.layer.masksToBounds = true
                    self?.answersStackView.addArrangedSubview(answerLabel)
                }
            })
            .disposed(by: disposeBag)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        viewModel.input.fetchNextQuestion.onNext(())
    }
}
