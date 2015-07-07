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
    
    func popToExpensesViewController(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let amount = amount?.text.amount {
            addExpense(amount)
            popToExpensesViewController()
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
            }) { (_) -> Void in
                UIView.animateWithDuration(0.5, animations: { [unowned self] in
                    self.amount.backgroundColor = self.amountDefaultBackgroundColor
                    })
        }
    }
}
