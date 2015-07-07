import UIKit

class SettingsViewController: UIViewController {

    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    func dismissViewController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
