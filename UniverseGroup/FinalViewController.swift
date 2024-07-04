//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 03.07.2024.
//

import Foundation
import RxSwift
import SnapKit

class FinalViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let closeButton = UIButton()
    private let mainText = UILabel()
    private let subText = UILabel()
    private let continueButton = UIButton()
    private let stackView = UIStackView()
    private let termsView = TermsView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white

        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "Onboarding4Light")
        view.addSubview(imageView)

        continueButton.setTitle("Start Now", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.shadowColor = UIColor(white: 0.5, alpha: 0.25).cgColor
        continueButton.layer.shadowOpacity = 1
        continueButton.layer.shadowOffset = CGSize(width: 0, height: -4)
        continueButton.layer.shadowRadius = 36
        continueButton.backgroundColor = .black
        continueButton.layer.cornerRadius = 28
        continueButton.layer.masksToBounds = true
        continueButton.titleLabel?.font = UIFont.font(.SFPRODISPLAYBOLD, ofSize: 17)
        view.addSubview(continueButton)

        mainText.text = "Discover all\nPremium features"
        mainText.font = UIFont.font(.SFPRODISPLAYBOLD, ofSize: 32)
        mainText.numberOfLines = 2
        mainText.textAlignment = .left
        view.addSubview(mainText)
        
        
        subText.text = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        subText.font = UIFont.font(.SFPRODISPLAYMEDIUM, ofSize: 16)
        subText.numberOfLines = 2
        subText.textColor = UIColor(red: 110/255, green: 110/255, blue: 115/255, alpha: 1)
        subText.textAlignment = .left
        view.addSubview(subText)
        
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor(red: 58/255, green: 60/255, blue: 61/255, alpha: 1)
        view.addSubview(closeButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        closeButton.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.right.equalToSuperview().offset(-20)
        }
        mainText.snp.makeConstraints{make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        subText.snp.makeConstraints{make in
            make.top.equalTo(mainText.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(termsView)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(104)
        }
        termsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(29)
        }
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        

        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        print("Continue button tapped on final screen")
    }
    
    @objc private func closeButtonTapped() {
        print("Close button tapped on final screen")
    }
}


