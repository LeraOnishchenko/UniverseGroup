//
//  File.swift
//  UniverseGroup
//
//  Created by lera on 04.07.2024.
//
import Foundation
import StoreKit
import RxSwift

protocol SubsViewModelInput {
    var purchaseButtonTapped: AnyObserver<Void> { get }
}

protocol SubsViewModelOutput {
    var fetched: Observable<String> { get }
}

class SubscriptionViewModel: SubsViewModelInput, SubsViewModelOutput {
    private let purchaseButtonTappedSubject = PublishSubject<Void>()
    private let fetchedSubject = BehaviorSubject<String>(value: "")
    
    var purchaseButtonTapped: AnyObserver<Void>
    var fetched: Observable<String>
    
    private let productID = "product"
    private var price = ""
    
    private let disposeBag = DisposeBag()

    init() {
        purchaseButtonTapped = purchaseButtonTappedSubject.asObserver()
        fetched = fetchedSubject.asObservable()
        fetchProduct()
        purchaseButtonTappedSubject.subscribe(onNext: {
            IAPService.shared.purchaseProduct()
        })
        .disposed(by: disposeBag)
    }
    
    private func fetchProduct() {
        IAPService.shared.fetchProductSingle()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: {[weak self] product in
                
                if product == nil {
                    self?.fetchedSubject.onNext("")
                    return
                }
                
                self?.price = product!.displayPrice
                self?.fetchedSubject.onNext(product!.displayPrice)
            },
                       onFailure: {
                [weak self] err in
                print(err)
                self?.fetchedSubject.onNext("")
            })
            .disposed(by: disposeBag)
     }
    }

