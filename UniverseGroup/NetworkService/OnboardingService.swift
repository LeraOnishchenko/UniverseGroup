//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 30.06.2024.
//
import Foundation
import RxSwift

class OnboardingService {
    public static var shared = OnboardingService()
    
    func fetchOnboardingDataSingle() -> Single<[OnboardingStep]>{
        Single<[OnboardingStep]>.create { single in
            let url = URL(string: "https://test-ios.universeapps.limited/onboarding")!
                
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    single(.failure(error))
                }
                else if let data = data {
                    do{
                        let steps = try JSONDecoder().decode(Items.self, from: data)
                        single(.success(steps.items))
                    }catch {
                        print(error)
                        single(.failure(error))
                    }
                }
            }
            
        task.resume()
            return Disposables.create {
                    task.cancel()
                }
        }
    }
}
