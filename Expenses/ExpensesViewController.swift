import UIKit
import RealmSwift
import Crashlytics

class ExpensesViewController: UIViewController, UITableViewDataSource {
    
    var array = Realm().objects(Expense).sorted("date",ascending:false)
    var notificationToken: NotificationToken?
    
    var currentSummary = 0
    var nextSummaryNSTimer:NSTimer?
    var updateSummaryInProgress = false
    
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var expensesTableView: UITableView!
    @IBOutlet weak var initialView: UIView!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewDataSource()
        setNotificationsForRealmUpdates()
    }
    
    func setTableViewDataSource(){
        self.expensesTableView.dataSource = self;
    }
    
    func setNotificationsForRealmUpdates(){
        notificationToken = Realm().addNotificationBlock { [unowned self] note, realm in
            self.updateUI()
        }
    }
    
    // MARK: viewDidAppear
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI(){
        updateSummary()
        showInitialViewIfThereAreNoExpenses()
        expensesTableView.reloadData()
    }
    
    func updateSummary(){
        updateSummaryInProgress = true
        
        UIView.transitionWithView(self.summary, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.summary.text = Balance.summaries[self.currentSummary]
            }) { (completion) -> Void in
                self.updateSummaryInProgress = false
        }
        
        startTimerToShowNextSummary()
    }
    
    func showInitialViewIfThereAreNoExpenses(){
        let thereAreNoExpenses = (array.count == 0)
        initialView.hidden = thereAreNoExpenses ? false : true
    }
    
    func startTimerToShowNextSummary(){
        nextSummaryNSTimer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "tick:", userInfo: nil, repeats: false)
    }
    
    func tick(nsTimer: NSTimer) {
        nextSummary()
    }
    
    @IBAction func nextSummary() {
        if !updateSummaryInProgress {
            nextSummaryNSTimer?.invalidate()
            nextSummaryNSTimer = nil
            currentSummary = (currentSummary + 1) % Balance.summaries.count
            updateSummary()
        }
    }
    
    // MARK: TableView Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(k.ExpenseCell) as? ExpensesTableViewCell {
            
            let expense = array[indexPath.row]
            cell.person = paidBy(expense.paidBy,To:expense.paidTo)
            cell.category = expense.category
            cell.amount = expense.amount.currency
            cell.date = formatDate(expense.date)
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func paidBy(paidBy:Int,To paidTo:Int)->String{
        let person1Name = k.Person1Name
        let person2Name = k.Person2Name
        
        let person1FirstLetter:String
        let person2FirstLetter:String
        
        if person1Name == "default_person_1_name".localized {
            person1FirstLetter = "P1"
        }
        else {
            person1FirstLetter = String(person1Name[person1Name.startIndex])
        }
        
        if person2Name == "default_person_2_name".localized {
            person2FirstLetter = "P2"
        }
        else {
            person2FirstLetter = String(person2Name[person2Name.startIndex])
        }
        
        let FirstSeparator = ""
        let SecondSeparator = " -> "
        var result = ""
        
        if paidBy == 0 {
            result += FirstSeparator + person1FirstLetter
        }
        
        if paidBy == 1 {
            result += FirstSeparator + person2FirstLetter
        }
        
        if paidTo == 0 {
            result += SecondSeparator +  person1FirstLetter
        }
        
        if paidTo == 1 {
            result += SecondSeparator +  person2FirstLetter
        }
        
        return result
    }
    
    func formatDate(date: NSDate)->String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.stringFromDate(date).uppercaseString
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let entry = array[indexPath.row]
            
            let inCommon = (entry.paidTo == 2) ? "Yes" : "No"
            let categoryPresent = (entry.category != "") ? "Yes" : "No"
            Answers.logCustomEventWithName("Expense Deleted", customAttributes:  [
                "In Common": inCommon,
                "Category Present": categoryPresent])
            
            RealmUtilities.deleteEntry(entry)
        }
    }
}

