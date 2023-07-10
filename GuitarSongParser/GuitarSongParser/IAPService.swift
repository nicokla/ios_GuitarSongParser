import Foundation
import StoreKit

class IAPService: NSObject{
    private override init() {}
    
    static let shared = IAPService()
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts(){
        // !!!
let products: Set = [IAPProduct.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct){ // !!!
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePutchases(){
        print("restoring purchases")
        paymentQueue.restoreCompletedTransactions()
    }
}


extension IAPService : SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse){
        self.products = response.products
        for product in response.products{
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions{
            print(transaction.transactionState)
            switch transaction.transactionState{
            case .purchasing:
                break
            case .purchased:
                queue.finishTransaction(transaction)
                globalVar.mymax[0].a = "100000"
                globalVar.saveMax()
                break
            case .failed:
                queue.finishTransaction(transaction)
                break
            case .restored:
                queue.finishTransaction(transaction)
                break
                
            default: break

            }
        }
    }
}

extension SKPaymentTransactionState{
    func status() -> String{
        switch self{
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}









