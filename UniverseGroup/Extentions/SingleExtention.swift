//
//  SingleExtention.swift
//  UniverseGroup
//
//  Created by lera on 04.07.2024.
//

import StoreKit
import RxSwift

extension Single {
    static func fromAsync<T>(_ fn: @escaping () async throws -> T) -> Single<T> {
        .create { single in
            let task = Task {
                do { try await single(.success(fn())) }
                catch { single(.failure(error))}
            }
            return Disposables.create { task.cancel() }
        }
    }
}
