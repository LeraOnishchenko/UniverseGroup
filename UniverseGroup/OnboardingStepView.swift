//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 30.06.2024.
//
import UIKit
import SnapKit

class OnboardingStepView: UIView {
    private let titleLabel = UILabel()
    private var optionButtons = [UIButton]()

    init(step: OnboardingStep) {
        super.init(frame: .zero)
        setup(step: step)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(step: OnboardingStep) {
        titleLabel.text = step.question
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }

        var previousButton: UIButton? = nil
        for option in step.answers {
            let button = UIButton()
            button.setTitle(option, for: .normal)
            button.backgroundColor = .lightGray
            addSubview(button)
            button.snp.makeConstraints { make in
                if let previous = previousButton {
                    make.top.equalTo(previous.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(titleLabel.snp.bottom).offset(20)
                }
                make.centerX.equalToSuperview()
                make.height.equalTo(44)
            }
            previousButton = button
            optionButtons.append(button)
        }
    }
}
