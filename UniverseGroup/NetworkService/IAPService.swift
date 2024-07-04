//
//  IAPService.swift
//  UniverseGroup
//
//  Created by lera on 04.07.2024.
//

import Foundation

import StoreKit
import RxSwift

class IAPService {
    private let productID = "product"
    private var storeProduct: Product?
    
    public static var shared = IAPService()
    
    init() {
        listenForTransactions()
    }
    
    
    public func fetchProductSingle() -> Single<Product?> {
        return Single<Product?>.fromAsync {
            await self.asyncFetchProduct()
        }
    }
    
    private func asyncFetchProduct() async -> Product?{
             do {
                 let storeProducts = try await Product.products(for: [productID])
                 if let storeProduct = storeProducts.first {
                     self.storeProduct = storeProduct
                     print("products initialized")
                 } else {
                     print("Product not found")
                 }
             } catch {
                 print("Failed to fetch product: \(error)")
             }
        return self.storeProduct
     }
    
    func purchaseProduct() {
        Task {
            do {
                guard let storeProduct = storeProduct else {return}
                let result = try await storeProduct.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        print("Purchase successful: \(transaction)")
                    case .unverified(_, let error):
                        print("Unverified transaction: \(error)")
                    }
                case .userCancelled:
                    print("User cancelled the purchase")
                case .pending:
                    print("Purchase pending")
                @unknown default:
                    break
                }
            } catch {
                print("Failed to purchase product: \(error)")
            }
        }
    }

    
    private func checkSubscriptionStatus() {
            Task {
                for await verificationResult in Transaction.currentEntitlements {
                    switch verificationResult {
                    case .verified(let transaction):
                        print("Verified subscription: \(transaction)")
                    case .unverified(_, let error):
                        print("Unverified subscription: \(error)")
                    }
                }
            }
        }
        
        private func listenForTransactions() {
            Task {
                for await verificationResult in Transaction.updates {
                    switch verificationResult {
                    case .verified(let transaction):
                        await transaction.finish()
                        print("Transaction update successful: \(transaction)")
                        checkSubscriptionStatus()
                    case .unverified(_, let error):
                        print("Unverified transaction update: \(error)")
                    }
                }
            }
        }
    
}
