import UIKit

class PremiumViewController: UIViewController {
    @IBOutlet weak var buttonPurchase: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //buttonPurchase.backgroundColor = .clear
        buttonPurchase.layer.cornerRadius = 5
        buttonPurchase.layer.borderWidth = 1
        buttonPurchase.layer.borderColor = UIColor.black.cgColor
        buttonPurchase.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)

        IAPService.shared.getProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func purchasePremium(_ sender: Any) {
        IAPService.shared.purchase(product: .nonConsumable)
        // IAPService.shared.restorePurchases()
        
        /*let alert = UIAlertController(title:  "IAP Tutorial", message: "You've successfully unlocked the Premium version!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)*/
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




















