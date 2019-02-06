//
//  ShoppingListViewController.swift
//  ShopLeave
//
//  Created by Paczeika Dan on 23/10/2018.
//  Copyright © 2018 Paczeika Dan. All rights reserved.
//

import UIKit
var totalPriceInEur : Double = 0.0
import Firebase
//var logoImage: [UIImage] = [
//    UIImage(named: "smiley.png")!,
//   UIImage(named: "smiley.png")!
//

let database = Database.database().reference()
let storage = Storage.storage().reference()
//let tempImageRef = storage.child("Images/\(myProduct[i]).jpg")
class ShoppingListViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate  , PayPalPaymentDelegate{
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProduct.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let tempImageRef = storage.child("Images/\(myProduct[indexPath.row]).png")
        //    i=indexPath.row
        tempImageRef.getData(maxSize: (1*1000*1000)) { (data, error) in
            if (error == nil)
            {
                print("am reusit")
                cell.imageView?.image = UIImage(data: data!)
            }
            else
            {
                print("error")
            }
        }
        
        cell.textLabel?.text = myProduct[indexPath.row] + "    " + String(myPrice[indexPath.row]) + " RON "

        
        
        
        
        
        //   cell.imageView?.image = logoImage[indexPath.row]
        // let imageRef = (UIApplication.shared.delegate as! AppDelegate).firebaseStorage?.reference().child("Images").child.(myProduct.)
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            myProduct.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            totalPriceLabel.text = "Total Price: " + String(totalPrice-myPrice[indexPath.row]) + " RON"
            totalPrice = totalPrice - myPrice[indexPath.row]
            myPrice.remove(at: indexPath.row)
            print(indexPath.row)
            print(totalPrice)
        }
        
    }
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
    }
    
    
    var payPalConfig = PayPalConfiguration()
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        totalPriceLabel.text = "Total Price: " + String(totalPrice) + " RON"
        
        
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Carrefour S.A."
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.sivaganesh.com/privacy.html") as! URL
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.sivaganesh.com/useragreement.html") as! URL
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages[0] as! String
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        PayPalMobile.preconnect(withEnvironment: environment)
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view.
    }
    
    @IBAction func payPressed(_ sender: Any) {
        totalPriceInEur = totalPrice/4.66
        totalPriceInEur = (totalPriceInEur*100).rounded()/100
        var item1 = PayPalItem(name: "Carrefour S.A. ", withQuantity: 1, withPrice: NSDecimalNumber(string: "\(totalPriceInEur)"), withCurrency: "EUR", withSku: "Carrefour-01")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPrice(forItems: items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.adding(shipping).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Carrefour S.A.", intent: .sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            
            print("Payment not processalbe: \(payment)")
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
