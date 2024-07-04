//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 30.06.2024.
//
import Foundation

struct Items: Decodable {
    let items: [OnboardingStep]
}

struct OnboardingStep: Decodable {
    let id: Int
    let answers: [String]
    let question: String
}
