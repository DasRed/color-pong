//
//  Store.swift
//  Color Pong
//
//  Created by Marco Starker on 26.01.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import StoreKit

class Store: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // the controller for some handling
    var controller: GameViewController!
    
    // the delegate for some handling
    var delegate: StoreDelegate!
    
    // the products
    var products: [Store.Product.Identifier: Store.Product?] = [
        Store.Product.Identifier.removeAd: nil
    ]
    
    // init
    init(controller: GameViewController, delegate: StoreDelegate) {
        super.init()
        
        self.controller = controller
        self.delegate = delegate

        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        self.requestProductData()
    }
    
    // request the product data
    func requestProductData() -> Store {
        // payments possible
        if (SKPaymentQueue.canMakePayments()) {
            var productIdentifiers: [String] = []
            for productKey in self.products.keys {
                productIdentifiers.append(productKey.full())
            }
            
            let request = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
            
            request.delegate = self
            request.start()
        }
            
            // payments not possible
        else {
            SCLAlertView().showError("In-App Käufe sind deaktiviert".localized, subTitle: "Bitte aktiviere In-App Käufe in den Einstellungen".localized, closeButtonTitle: "Okay".localized)
        }
        
        return self
    }
    
    // callback on products request
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        if (response.products.count == 0) {
            return
        }
        
        var productIdentifier: Store.Product.Identifier?
        for product in response.products {
            productIdentifier = Store.Product.Identifier.get(product.productIdentifier)
            
            if (productIdentifier == nil) {
                NSLog("Could not handle product with identifier %@.", product.productIdentifier)
                continue
            }
            
            self.products[productIdentifier!] = Store.Product(product: product, identifier: productIdentifier!, controller: self.controller)
        }
    }

    // returns a product
    func get(productIdentifier: Store.Product.Identifier) -> Store.Product! {
        return self.products[productIdentifier]!
    }
    
    // returns a product by string
    func get(productIdentifier productIdentifierName: String) -> Store.Product? {
        let productIdentifier = Store.Product.Identifier.get(productIdentifierName)
        if (productIdentifier == nil) {
            return nil
        }
        
        if (self.products[productIdentifier!] == nil) {
            return nil
        }
        
        return self.products[productIdentifier!]!
    }
    
    // restore purchases
    func restoreAll() -> Store {
        LoadingOverlay.shared.showOverlay(self.controller.view)

        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        
        return self
    }
    
    // payment queue
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var product: Store.Product?
        
        for transaction in transactions {
            product = self.get(productIdentifier: transaction.payment.productIdentifier)
            if (product == nil) {
                continue
            }

            // handle transaction
            if (transaction.transactionState == SKPaymentTransactionState.Purchased) {
                self.delegate.productWasBuyed(product!)
            }
            
            switch (transaction.transactionState) {
            case .Restored:
                NSLog("%@: Restored", transaction.payment.productIdentifier)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                LoadingOverlay.shared.hideOverlayView()
                break
                
            case .Purchasing:
                NSLog("%@: Purchasing", transaction.payment.productIdentifier)
                break
                
            case .Purchased:
                NSLog("%@: Purchased", transaction.payment.productIdentifier)
                self.delegate.productWasBuyed(product!)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                LoadingOverlay.shared.hideOverlayView()
                break
                
            case .Failed:
                NSLog("%@: Failed (%@)", transaction.payment.productIdentifier, transaction.error!)
                SCLAlertView().showError("Payment Error".localized, subTitle: String(transaction.error!), closeButtonTitle: "Okay".localized)

                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                LoadingOverlay.shared.hideOverlayView()
                break
                
            case .Deferred:
                NSLog("%@: Deferred", transaction.payment.productIdentifier)
                break
            }
        }
    }
    
    // restoring
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        var product: Store.Product?

        for transaction in queue.transactions {
            product = self.get(productIdentifier: transaction.payment.productIdentifier)
            if (product == nil) {
                continue
            }
            
            self.delegate.productWasBuyed(product!)
        }
        
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        NSLog("Restore failed: %@", error)
        SCLAlertView().showError("Payment Error".localized, subTitle: String(error), closeButtonTitle: "Okay".localized)

        LoadingOverlay.shared.hideOverlayView()
    }
    
    /*************************
     * Product Class         *
     *************************/
    class Product: NSObject {
        // Use enum as a simple namespace.
        enum Identifier: String {
            case removeAd = "removead"
            
            static func get(value: String) -> Product.Identifier? {
                switch (value) {
                case Identifier.removeAd.rawValue:
                    return Identifier.removeAd
                
                case Identifier.removeAd.full():
                    return Identifier.removeAd
                
                default:
                    return nil
                }
            }
            
            func full() -> String {
                return NSBundle.mainBundle().bundleIdentifier! + "." + self.rawValue
            }
        }
        
        // identifiert
        let identifier: Identifier!

        // the product
        let product: SKProduct!

        private let controller: GameViewController!
        
        // constructor
        init(product: SKProduct, identifier: Identifier, controller: GameViewController) {
            self.product = product
            self.identifier = identifier
            self.controller = controller

            super.init()
        }
        
        // buy a product by ident
        func buy() -> Bool {
            LoadingOverlay.shared.showOverlay(self.controller.view)
            let payment = SKPayment(product: self.product)
            SKPaymentQueue.defaultQueue().addPayment(payment)
            
            return true
        }
    }
}