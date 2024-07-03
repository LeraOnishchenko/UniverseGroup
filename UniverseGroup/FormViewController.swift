//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 02.07.2024.
//
import UIKit
import RxSwift
import SnapKit

class FormViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: FormViewModel
    private let mainText = UILabel()
    private let questionLabel = UILabel()
    private let tableView = UITableView()
    private let continueButton = UIButton()
    
    init(viewModel: FormViewModel) {
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
        view.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 245/255, alpha: 1)
        mainText.text = "Let’s setup App for you"
        mainText.textAlignment = .left
        mainText.font = UIFont.font(.SFPRODISPLAYBOLD, ofSize: 26)
        view.addSubview(mainText)
        
        questionLabel.textAlignment = .left
        //lox
        questionLabel.font = UIFont.font(.SFPRODISPLAYMEDIUM, ofSize: 20)
        view.addSubview(questionLabel)
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnswerCell")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(UIColor(red: 202/255, green: 202/255, blue: 2002/255, alpha: 1), for: .normal)
        continueButton.backgroundColor = .white
        continueButton.layer.cornerRadius = 28
        continueButton.layer.masksToBounds = true
        continueButton.titleLabel?.font = UIFont.font(.SFPRODISPLAYBOLD, ofSize: 17)
                
        view.addSubview(continueButton)
        
        mainText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainText.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(continueButton.snp.top).offset(-20)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(56)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.centerX.equalToSuperview()
        }
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        viewModel.nextButtonTapped.onNext(())
    }
    
    private func bindViewModel() {
        viewModel.question
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] question in
                self?.continueButton.isUserInteractionEnabled = false
                self?.continueButton.setTitleColor(UIColor(red: 202/255, green: 202/255, blue: 2002/255, alpha: 1), for: .normal)
                self?.continueButton.backgroundColor = .white
                
                self?.questionLabel.text = question.question
                self?.tableView.reloadData()
                
            })
            .disposed(by: disposeBag)
        
        viewModel.isCompleted
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isCompleted in
                if isCompleted {
                    self?.navigateToFinalScreen()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedAnswer
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] answ in
                if (answ == nil){
                    return
                }
                self?.continueButton.setTitleColor(.white, for: .normal)
                self?.continueButton.backgroundColor = .black
                self?.continueButton.isUserInteractionEnabled = true
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToFinalScreen() {
        let finalViewController = FinalViewController()
        finalViewController.modalPresentationStyle = .fullScreen
        present(finalViewController, animated: true, completion: nil)
    }
}


