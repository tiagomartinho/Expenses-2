import UIKit
import SwiftyDropbox

class ViewController: UIViewController {
    
    @IBAction func linkDropbox(sender: UIBarButtonItem) {
        Dropbox.authorizeFromController(self)
    }
}

