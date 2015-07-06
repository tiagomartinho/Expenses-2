import UIKit

class ComposeExpenseViewController: UIViewController {

    @IBOutlet weak var person: UISegmentedControl!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var category: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.becomeFirstResponder()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if let person = person.titleForSegmentAtIndex(person.selectedSegmentIndex) {
            
        }

        dismissViewController()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
