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
        let date = NSDate()
        let categoryOrEmpty = category?.text ?? ""
        if let person = person.titleForSegmentAtIndex(person.selectedSegmentIndex) {
            let realm = Realm()
            realm.beginWrite()
            realm.create(Expense.self, value: [amount,categoryOrEmpty,person,date])
            realm.commitWrite()
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    func dismissViewController(){
        amount.resignFirstResponder()
        category.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
