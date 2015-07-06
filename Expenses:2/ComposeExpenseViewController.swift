import UIKit
import RealmSwift

class ComposeExpenseViewController: UIViewController {

    @IBOutlet weak var person: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var category: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.becomeFirstResponder()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let amount = amount?.text.amount {
            addExpense(amount)
            dismissViewController()
        }
        else {
            // TODO notify the user
        }
    }
    
    func addExpense(amount:Double) {
        if let person = person.titleForSegmentAtIndex(person.selectedSegmentIndex) {
            let realm = Realm()
            realm.beginWrite()
            let date = NSDate()
            let amount = amount
            realm.create(Expense.self, value: [amount, date])
            realm.commitWrite()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
