//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 03.07.2024.
//

import UIKit
import SnapKit

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
        termsLabel.numberOfLines = 0
        termsLabel.textAlignment = .center
        
        let text = "By continuing you accept our:\n "
        let termsOfUse = "Terms of Use"
        let privacyPolicy = "Privacy Policy"
        let subscriptionTerms = "Subscription Terms"
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.foregroundColor: UIColor.subText])
        
        attributedString.append(NSAttributedString(string: termsOfUse, attributes: [.foregroundColor: UIColor.termsText]))
        attributedString.append(NSAttributedString(string: ", ", attributes: [.foregroundColor: UIColor.subText]))
        attributedString.append(NSAttributedString(string: privacyPolicy, attributes: [.foregroundColor: UIColor.termsText]))
        attributedString.append(NSAttributedString(string: ", ", attributes: [.foregroundColor: UIColor.subText]))
        attributedString.append(NSAttributedString(string: subscriptionTerms, attributes: [.foregroundColor: UIColor.termsText]))
        
        termsLabel.attributedText = attributedString
        termsLabel.isUserInteractionEnabled = true
        termsLabel.font = UIFont.font(.SFPRODISPLAYREGULAR, ofSize: 12)
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            if let url = URL(string: "https://www.example.com") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            print("Terms of Use tapped")
        } else if recognizer.didTapAttributedTextInLabel(label: recognizer.view as! UILabel, inRange: privacyPolicyRange!) {
            if let url = URL(string: "https://www.example.com") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            print("Privacy Policy tapped")
        } else if recognizer.didTapAttributedTextInLabel(label: recognizer.view as! UILabel, inRange: subscriptionTermsRange!) {
            if let url = URL(string: "https://www.example.com") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            print("Subscription Terms tapped")
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
