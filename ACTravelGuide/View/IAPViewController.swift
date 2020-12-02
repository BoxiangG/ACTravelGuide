//
//  IAPViewController.swift
//  ACTravelGuide
//
//  Created by Boxiang Guo on 6/4/20.
//  Copyright © 2020 Boxiang Guo. All rights reserved.
//

import UIKit
import StoreKit

class IAPViewController: UIViewController,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var supportText: UITextView!
    @IBOutlet weak var littleTipLabel: UILabel!
    @IBOutlet weak var someTipLabel: UILabel!
    @IBOutlet weak var largeTipLabel: UILabel!
    
    
    var IAPlist = [SKProduct]()
    var p = SKProduct()
    
    @IBOutlet weak var littleTipButtonText: UIButton!
    @IBOutlet weak var someTipButtonText: UIButton!
    @IBOutlet weak var largeTipButtonText: UIButton!
    
    
    @IBAction func littleTipButton(_ sender: Any) {
        for product in IAPlist {
            let prodID = product.productIdentifier
            if(prodID == "com.Boxiang.ACGuide.8CNY") {
                p = product
                buyProduct()
            }
        }
    }
    
    @IBAction func someTipButton(_ sender: Any) {
        for product in IAPlist {
            let prodID = product.productIdentifier
            if(prodID == "com.Boxiang.ACGuide.18CNY") {
                p = product
                buyProduct()
            }
        }
    }
    
    @IBAction func largeTipButton(_ sender: Any) {
        for product in IAPlist {
            let prodID = product.productIdentifier
            if(prodID == "com.Boxiang.ACGuide.40CNY") {
                p = product
                buyProduct()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportText.text = "supportText".localized()
        littleTipLabel.text = "littleTip".localized()
        someTipLabel.text = "someTip".localized()
        largeTipLabel.text = "largeTip".localized()
        
        littleTipButtonText.isEnabled = false
        someTipButtonText.isEnabled = false
        largeTipButtonText.isEnabled = false
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects:"com.Boxiang.ACGuide.8CNY", "com.Boxiang.ACGuide.18CNY",  "com.Boxiang.ACGuide.40CNY")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
    }
    
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProduct = response.products
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            IAPlist.append(product)
            
        }
        
        
        DispatchQueue.main.async {
            
            self.littleTipButtonText.isEnabled = true
            self.someTipButtonText.isEnabled = true
            self.largeTipButtonText.isEnabled = true
            
            for product in self.IAPlist{
                switch product.productIdentifier as String{
                case "com.Boxiang.ACGuide.8CNY":
                    self.littleTipButtonText.setTitle(product.regularPrice, for: .normal)
                    
                case "com.Boxiang.ACGuide.18CNY":
                    self.someTipButtonText.setTitle(product.regularPrice, for: .normal)
                case "com.Boxiang.ACGuide.40CNY":
                    self.largeTipButtonText.setTitle(product.regularPrice, for: .normal)
                default:
                    print("IAP not found")
                }
            }
            
            
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
                
            case "com.Boxiang.ACGuide.8CNY":
                print("8yuan")
            case "com.Boxiang.ACGuide.18CNY":
                print("18yuan")
            case "com.Boxiang.ACGuide.40CNY":
                print("40yuan")
            default:
                print("IAP not found")
            }
        }
    }
    
    
    func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                    
                case "com.Boxiang.ACGuide.8CNY":
                    print("8块钱")
                case "com.Boxiang.ACGuide.18CNY":
                    print("18块钱")
                case "com.Boxiang.ACGuide.40CNY":
                    print("40块钱")
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
        }
    }
    
}
extension SKProduct {
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
