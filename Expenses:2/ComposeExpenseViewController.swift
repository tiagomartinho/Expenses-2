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
        if Expense.isAmountValid(amount?.text) {
            addExpense()
            dismissViewController()
        }
        else {
            // TODO notify the user
        }
    }
    
    func addExpense() {
        if let person = person.titleForSegmentAtIndex(person.selectedSegmentIndex) {
            let realm = Realm()
            realm.beginWrite()
            let date = NSDate()
            let amount = 0
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
