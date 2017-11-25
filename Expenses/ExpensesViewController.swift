import UIKit
import RealmSwift
import Crashlytics

class ExpensesViewController: UIViewController, UITableViewDataSource {
    
    var array = try! Realm().objects(Expense.self).sorted("date",ascending:false)
    var notificationToken: NotificationToken?
    
    var currentSummary = 0
    var nextSummaryNSTimer:Timer?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI(){
        updateSummaryWithAnimation(false)
        showInitialViewIfThereAreNoExpenses()
        expensesTableView.reloadData()
    }
    
    func updateSummaryWithAnimation(_ animation:Bool){
        updateSummaryInProgress = true
        
        let animationDuration = animation ? 0.3 : 0.0
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.summary.alpha = 0.0
            }) { finished -> Void in
                self.summary.text = Balance.summaries[self.currentSummary]
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                    self.summary.alpha = 1.0
                    }) { (completion) -> Void in
                        self.updateSummaryInProgress = false
                }
        }
    
        startTimerToShowNextSummary()
    }
    
    func showInitialViewIfThereAreNoExpenses(){
        let thereAreNoExpenses = (array.count == 0)
        initialView.hidden = thereAreNoExpenses ? false : true
    }
    
    func startTimerToShowNextSummary(){
        nextSummaryNSTimer = Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(ExpensesViewController.tick(_:)), userInfo: nil, repeats: false)
    }
    
    func tick(_ nsTimer: Timer) {
        nextSummary()
    }
    
    @IBAction func nextSummary() {
        if !updateSummaryInProgress {
            nextSummaryNSTimer?.invalidate()
            nextSummaryNSTimer = nil
            currentSummary = (currentSummary + 1) % Balance.summaries.count
            updateSummaryWithAnimation(true)
        }
    }
    
    // MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: k.ExpenseCell) as? ExpensesTableViewCell {
            
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
    
    func paidBy(_ paidBy:Int,To paidTo:Int)->String{
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
    
    func formatDate(_ date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        return dateFormatter.string(from: date).uppercased()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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

