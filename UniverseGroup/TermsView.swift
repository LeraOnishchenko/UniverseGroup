//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 03.07.2024.
//

import UIKit
//import SnapKit

class TermsView: UIView {
    
    let termsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Настройка метки
        termsLabel.numberOfLines = 0
        termsLabel.textAlignment = .center
        
        // Атрибутированный текст
        let text = "By continuing you accept our: "
        let termsOfUse = "Terms of Use"
        let privacyPolicy = "Privacy Policy"
        let subscriptionTerms = "Subscription Terms"
        
        let attributedString = NSMutableAttributedString(string: text)
        let termsOfUseRange = NSRange(location: text.count, length: termsOfUse.count)
        let privacyPolicyRange = NSRange(location: text.count + termsOfUse.count + 2, length: privacyPolicy.count)
        let subscriptionTermsRange = NSRange(location: text.count + termsOfUse.count + privacyPolicy.count + 4, length: subscriptionTerms.count)
        
        attributedString.append(NSAttributedString(string: termsOfUse, attributes: [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        attributedString.append(NSAttributedString(string: ", ", attributes: [:]))
        attributedString.append(NSAttributedString(string: privacyPolicy, attributes: [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        attributedString.append(NSAttributedString(string: ", ", attributes: [:]))
        attributedString.append(NSAttributedString(string: subscriptionTerms, attributes: [.foregroundColor: UIColor.blue, .underlineStyle: NSUnderlineStyle.single.rawValue]))
        
        termsLabel.attributedText = attributedString
        termsLabel.isUserInteractionEnabled = true
        
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        termsLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func labelTapped(_ recognizer: UITapGestureRecognizer) {
        let text = (recognizer.view as! UILabel).attributedText?.string
        let termsOfUseRange = (text as NSString?)?.range(of: "Terms of Use")
        let privacyPolicyRange = (text as NSString?)?.range(of: "Privacy Policy")
        let subscriptionTermsRange = (text as NSString?)?.range(of: "Subscription Terms")
        
        if recognizer.didTapAttributedTextInLabel(label: recognizer.view as! UILabel, inRange: termsOfUseRange!) {
            print("Terms of Use tapped")
            // Handle Terms of Use tap
        } else if recognizer.didTapAttributedTextInLabel(label: recognizer.view as! UILabel, inRange: privacyPolicyRange!) {
            print("Privacy Policy tapped")
            // Handle Privacy Policy tap
        } else if recognizer.didTapAttributedTextInLabel(label: recognizer.view as! UILabel, inRange: subscriptionTermsRange!) {
            print("Subscription Terms tapped")
            // Handle Subscription Terms tap
        }
    }
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }

        let mutableStr = NSMutableAttributedString(attributedString: attributedText)
        mutableStr.addAttributes([NSAttributedString.Key.font: label.font ?? UIFont.systemFont(ofSize: 12)], range: NSRange(location: 0, length: attributedText.length))
        
        let textStorage = NSTextStorage(attributedString: mutableStr)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        layoutManager.addTextContainer(textContainer)

        let locationOfTouchInLabel = self.location(in: label)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInLabel, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
