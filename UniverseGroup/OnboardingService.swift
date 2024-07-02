//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 30.06.2024.
//
import Foundation
import RxSwift

class OnboardingService {
    func fetchOnboardingData(completion: @escaping ([OnboardingStep]?) -> Void) {
        guard let url = URL(string: "https://test-ios.universeapps.limited/onboarding") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let steps = try JSONDecoder().decode(Items.self, from: data)
                completion(steps.items)
            } catch {
                print(error)
                completion(nil)
            }
        }
        task.resume()
    }
}
