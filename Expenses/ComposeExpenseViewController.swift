import UIKit
import Crashlytics

class ComposeExpenseViewController: UITableViewController {

    @IBOutlet weak var paidBy: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var paidTo: UISegmentedControl!
    @IBOutlet weak var category: UITextField!
    
    var amountDefaultBackgroundColor:UIColor?
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldShouldReturn.addTextField(category)
        amountDefaultBackgroundColor = amount.backgroundColor
        updateSegmentedControl()
    }
    
    func updateSegmentedControl(){
            paidBy.setTitle(k.Person1Name, forSegmentAt: 0)
            paidTo.setTitle(k.Person1Name, forSegmentAt: 0)
            paidBy.setTitle(k.Person2Name, forSegmentAt: 1)
            paidTo.setTitle(k.Person2Name, forSegmentAt: 2)
    }
    
    func popToExpensesViewController(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let amount = amount?.text?.amount {
            addExpense(amount)
            popToExpensesViewController()
        }
        else {
            setAmountBackground()
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    let paidToConversion = [0,2,1]
    func addExpense(_ amount:Double) {
        let categoryOrEmpty = category?.text ?? ""
        let by = paidBy.selectedSegmentIndex
        let to = paidToConversion[paidTo.selectedSegmentIndex]
        RealmUtilities.createEntryWithAmount(amount, PaidBy: by, PaidTo: to, AtDate: Date(), WithCategory: categoryOrEmpty)
        
        let inCommon = (to == 2) ? "Yes" : "No"
        let categoryPresent = (categoryOrEmpty != "") ? "Yes" : "No"
        Answers.logCustomEvent(withName: "Expense Added", customAttributes:  [
            "In Common": inCommon,
            "Category Present": categoryPresent])
    }
    
    func setAmountBackground(){
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.amount.backgroundColor = UIColor.red
            }, completion: { (_) -> Void in
                UIView.animate(withDuration: 0.5, animations: { [unowned self] in
                    self.amount.backgroundColor = self.amountDefaultBackgroundColor
                    })
        }) 
    }
}
