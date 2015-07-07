import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var person1: UITextField!
    @IBOutlet weak var person2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPersonsNames()
    }
    
    func loadPersonsNames(){
        if let person1Name = defaults.objectForKey(kUD_Person1) as? String {
            person1.text = person1Name
        }
        if let person2Name = defaults.objectForKey(kUD_Person2) as? String {
            person2.text = person2Name
        }
    }
    
    @IBAction func person(sender: UITextField) {
        let name = sender.text.removeWhitespaces()
        if name == "" {
            return
        }
        
        if sender.placeholder?.hasSuffix("1") ?? false {
            defaults.setObject(name, forKey: kUD_Person1)
        }
        
        if sender.placeholder?.hasSuffix("2") ?? false {
            defaults.setObject(name, forKey: kUD_Person2)
        }
        
        defaults.synchronize()
    }
}
