//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 03.07.2024.
//
import UIKit

public extension UIFont {
    enum Custom: String, CaseIterable {
        case SFPRODISPLAYBOLD = "SFProDisplay-Bold"
        case SFPRODISPLAYMEDIUM = "SFProDisplay-Medium"
        case SFPRODISPLAYREGULAR = "SFProDisplay-Regular"
    }

    static func font(_ font: Custom, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
