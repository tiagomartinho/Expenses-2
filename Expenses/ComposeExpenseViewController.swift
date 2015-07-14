import UIKit

class ComposeExpenseViewController: UITableViewController {

    @IBOutlet weak var paidBy: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var paidTo: UISegmentedControl!
    @IBOutlet weak var category: UITextField!
    
    var amountDefaultBackgroundColor:UIColor?
    
    let textFieldShouldReturn = TextFieldShouldReturn()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.becomeFirstResponder()
        textFieldShouldReturn.addTextField(category)
        amountDefaultBackgroundColor = amount.backgroundColor
        updateSegmentedControl()
    }
    
    func updateSegmentedControl(){
        if let person1Name = defaults.objectForKey(kUD_Person1) as? String {
            paidBy.setTitle(person1Name, forSegmentAtIndex: 0)
            paidTo.setTitle(person1Name, forSegmentAtIndex: 0)
        }
        if let person2Name = defaults.objectForKey(kUD_Person2) as? String {
            paidBy.setTitle(person2Name, forSegmentAtIndex: 1)
            paidTo.setTitle(person2Name, forSegmentAtIndex: 2)
        }
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
            tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    let paidToConversion = [0,2,1]
    func addExpense(amount:Double) {
        let categoryOrEmpty = category?.text ?? ""
        let by = paidBy.selectedSegmentIndex
        let to = paidToConversion[paidTo.selectedSegmentIndex]
        RealmUtilities.addEntryWithAmount(amount, PaidBy: by, PaidTo: to, AtDate: NSDate(), WithCategory: categoryOrEmpty)
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
