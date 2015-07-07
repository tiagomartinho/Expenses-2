import UIKit
import RealmSwift

class ComposeExpenseViewController: UIViewController {

    @IBOutlet weak var person: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var category: UITextField!
    
    var amountDefaultBackgroundColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.becomeFirstResponder()
        amountDefaultBackgroundColor = amount.backgroundColor
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    func dismissViewController(){
        amount.resignFirstResponder()
        category.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let amount = amount?.text.amount {
            addExpense(amount)
            dismissViewController()
        }
        else {
            setAmountBackground()
        }
    }
    
    func addExpense(amount:Double) {
        let date = NSDate()
        let categoryOrEmpty = category?.text ?? ""
        if let person = person.titleForSegmentAtIndex(person.selectedSegmentIndex) {
            let realm = Realm()
            realm.beginWrite()
            realm.create(Expense.self, value: [amount,categoryOrEmpty,person,date])
            realm.commitWrite()
        }
    }
    
    func setAmountBackground(){
        UIView.animateWithDuration(0.5, animations: { [unowned self] in
            self.amount.backgroundColor = UIColor.redColor()
            })
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "resetAmountBackground:", userInfo: nil, repeats: false)
    }
    
    func resetAmountBackground(nsTimer: NSTimer) {
        UIView.animateWithDuration(0.5, animations: { [unowned self] in
            self.amount.backgroundColor = self.amountDefaultBackgroundColor
            })
    }
}
